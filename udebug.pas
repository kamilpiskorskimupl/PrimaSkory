unit uDebug;

{$mode objfpc}{$h+}

interface

uses
  Classes, SysUtils, LazFileUtils, uMacAddress;

const
  L_NONE = 0;
  L_ERR  = 1;
  L_WARN = 2;
  L_INFO = 3;
  L_DEV  = 4;
  L_DEV2 = 5;

type TLogBlock = (tldNone, tldBegin, tldEnd);

type

{ TLog }

 TLog = class
  private
   tape : String;
   f : TFileStream;
   procedure Open;
   procedure Trim;
  public
   depth : Integer;
   bLogOn : Boolean;
   maxSize : Integer;
   level : Integer;
   bLocalEcho : Boolean;
   constructor Create(_tape : String; _maxSize : Integer = 1024*1024; _level : Integer = L_DEV );
   destructor Destroy; override;
   procedure log( msg      : String;
                  dcBefore : Integer = 0;
                  dcAfter  : Integer = 0);
   procedure logl( _level   : Integer;
                   msg      : String;
                   dcBefore : Integer = 0;
                   dcAfter  : Integer = 0);
   procedure loglx( _level   : Integer;
                    SClassName : ShortString;
                    SMethodName : ShortString;
                    msg      : String;
                    dcBefore : Integer;
                    dcAfter  : Integer = 0);
   procedure loglx( _level : Integer;
                    SClassName : String;
                    SMethodName : String;
                    msg : String;
                    block : TLogBlock); overload;
   procedure loglx( _level : Integer;
                    SClassName : String;
                    SMethodName : String;
                    msg : String); overload;
   procedure set_tape(_tape : String);
   class function GetTimeStamp : String;
   class procedure InitializeGlobalLog(_directory : String);
  end;

var
  _debug : TLog;

implementation

constructor TLog.Create(_tape : String; _maxSize : Integer; _level : Integer );
begin
 set_tape(_tape);
 depth := 0;
 maxSize := _maxSize;
 level := _level;
 bLogOn := true;
 bLocalEcho := false;
 Open;
end;

destructor TLog.Destroy;
begin
 try
  f.Destroy;
 except
 end;
end;

procedure TLog.Open;
var
  dir : String;
begin
  if f <> nil then f.Destroy;

  dir := ExtractFileDir(tape);
  if not DirectoryExistsUTF8(dir) then
    CreateDirUTF8(dir);

  if FileExistsUTF8(tape) then
   f := TFileStream.Create(tape, fmOpenReadWrite or fmShareDenyNone)
  else
   f := TFileStream.Create(tape, fmCreate or fmShareDenyNone);
  f.Seek(0, soFromEnd);
end;

procedure TLog.log( msg      : String;
                    dcBefore : Integer;
                    dcAfter  : Integer);
var i:Integer;
    s:String;
begin

 depth := depth + dcBefore;

 if bLogOn = true then
 try
  f.Seek(0,soFromEnd);
  s := GetTimeStamp + ' : ';
  f.Write( s[1], Length(s) );
  if bLocalEcho then Write(s);
  s := ' ';
  if depth > 0 then for i := 1 to depth do f.Write( s[1], 1 );
  msg := msg + LineEnding;
  f.Write( msg[1], Length(msg) );
  if bLocalEcho then Write(msg);
 finally
 end;

 Trim;
 depth := depth + dcAfter;
end;

procedure TLog.logl( _level : Integer;
                     msg : String;
                     dcBefore : Integer;
                     dcAfter : Integer);
begin
 if _level > level then Exit;
 log(msg, dcBefore, dcAfter);
end;

procedure TLog.loglx( _level   : Integer;
                      SClassName : ShortString;
                      SMethodName : ShortString;
                      msg      : String;
                      dcBefore : Integer;
                      dcAfter  : Integer);
begin
  if _level > level then Exit;
  logl(_level,SClassName+'.'+SMethodName+': '+msg,dcBefore,dcAfter);
end;

procedure TLog.loglx(_level: Integer; SClassName: String; SMethodName: String;
  msg: String; block: TLogBlock);
begin
  if _level > level then Exit;
  case block of
    tldNone  : loglx(_level, SClassName, SMethodName, msg, 0, 0);
    tldBegin : loglx(_level, SClassName, SMethodName, msg, 1, 0);
    tldEnd   : loglx(_level, SClassName, SMethodName, msg, 0, -1);
  end;
end;

procedure TLog.loglx(_level: Integer; SClassName: String; SMethodName: String;
  msg: String);
var
  block : TLogBlock;
begin
  if _level > level then Exit;
  if Pos('BEGIN', msg) = 1 then block := tldBegin
  else if Pos('END', msg) = 1 then block := tldEnd
  else block := tldNone;
  loglx(_level, SClassName, SMethodName, msg, block);
end;

procedure TLog.set_tape(_tape: String);
begin
 tape := _tape.Replace(
   '%GlobalAppConfigDir%', GetAppConfigDirUTF8(true), [rfReplaceAll]);
 tape := tape.Replace(
   '%LocalAppConfigDir%', GetAppConfigDirUTF8(false), [rfReplaceAll]);
end;

class function TLog.GetTimeStamp: String;
begin
 Result := FormatDateTime('YYYY-MM-DD hh:nn:ss.zzz', Now);
end;

class procedure TLog.InitializeGlobalLog(_directory: String);
var
  new_tape : String;
  DebugInitHostName, DebugInitUserName : String;
begin
 if (Length(_directory) > 0)
 and (not _directory.EndsWith(DirectorySeparator)) then
   _directory += DirectorySeparator;
 DebugInitHostName := TMacAddress.GetHostName;
 DebugInitUserName := TMacAddress.GetUserName;
 new_tape :=
   _directory + DebugInitHostName+'-'+DebugInitUserName+'-'+'global.log';
 if Assigned(_debug) then begin
   _debug.set_tape(new_tape);
   _debug.Open;
 end else
   _debug := TLog.Create(new_tape, 50*1024*1024);
end;

procedure TLog.Trim;
var oldName : String;
    newName : String;
begin
 if (bLogOn = true) and (f.Position > maxSize) then
 try
  f.Destroy;
  f := nil;
  oldName := tape;
  newName := tape + '.bak';
  DeleteFileUTF8(newName ); { *Converted from DeleteFile* }
  RenameFileUTF8(oldName,newName ); { *Converted from RenameFile* }
  Open;
 finally
 end;
end;

initialization
  _debug := nil;

finalization
  if Assigned(_debug) then _debug.Free;

end.

