unit uConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, udsencrypt, uversion, udebug, uMacAddress;

type

{ TConfig }

 TConfig = class
  private
    PGlobalDir : String;
    PLocalDir : String;
  public
    // General
    sFile_Restore,
    sFile_Store : String;

    // Program
    bHideStart : Boolean;
    sDeviceId,
    sLauncher_Path,
    sLauncher_Ini_Path : String;
    bChangeAction : Boolean;

    // Modules
    ModDrukowanie : Boolean;

    // Debug
    bLocalEcho : Boolean;
    iLevel,
    iMaxSize : Integer;
    bDebugZeos : Boolean;
    sLogPath : String;

    //Language
    sDictionaryFile  : String;
    sSelectedLanguage : ShortString;
    sLangCode : ShortString;

    // Database
    sDB_Server,
    sDB_Database,
    sDB_UserName,
    sDB_Password,
    sDB_Protocol,
    sDB_Library,
    sDB_CtrlsCP,
    sDB_ClientCP : String;

    iDB_Port : Integer;

    bDB_AutoEncodeStrings : Boolean;
    property GlobalDir : String read PGlobalDir;
    property LocalDir : String read PLocalDir;

    constructor Create;

    procedure Restore(fname : String = '');
    procedure Store(fname : String = '');
end;

var
  Config : TConfig;
  configFile : String;

procedure LoadConfig;
procedure SaveConfig;

implementation

procedure LoadConfig;
var sHostName, sUserName : String;
begin
  if not Assigned(Config) then Config := TConfig.Create;
  {$IFDEF Windows}
  sHostName := LowerCase(GetEnvironmentVariable('COMPUTERNAME'));
  {$ELSE}
  sHostName := GetEnvironmentVariable('HOSTNAME');
  {$ENDIF}
  sUserName := LowerCase(GetEnvironmentVariable('USERNAME'));

  configFile := '';
  if ParamCount > 0 then begin
    configFile := ParamStr(1);
    if not FileExists(configFile) then configFile := '';
  end;
  if configFile = '' then begin
    configFile := sHostName+'-'+sUserName+'-config.ini';
    if not FileExists(configFile) then configFile := '';
  end;
  if configFile = '' then begin
    configFile := sHostName+'-config.ini';
    if not FileExists(configFile) then configFile := '';
  end;
  if configFile = '' then begin
    configFile := 'config.ini';
  end;
  Config.Restore(configFile);
end;

procedure SaveConfig;
begin
  Config.Store(configFile);
end;

constructor TConfig.Create;
begin
  {$IFDEF Unix}
  PGlobalDir := GetCurrentDir;
  {$ELSE}
  PGlobalDir := GetAppConfigDir(true);
  {$ENDIF}
  if not DirectoryExists(GlobalDir) then CreateDir(GlobalDir);
  PLocalDir := GetAppConfigDir(false);
  if not DirectoryExists(LocalDir) then CreateDir(LocalDir);

  sFile_Restore := 'config.ini';
  sFile_Store := 'config.ini';
  bHideStart := false;
  sDeviceId := TMacAddress.GetMacAddress;
  sLauncher_Path := 'desktoplauncher.exe';
  sLauncher_Ini_Path := 'desktop-launcher.ini';

  ModDrukowanie := true;
  bChangeAction := false;

  bLocalEcho := false;
  iLevel := L_ERR;
  iMaxSize := 10*1024*1024;
  sLogPath := '';

  sDB_Server := 'LOCALHOST\SQL2014';
  iDB_Port := 0;
  sDB_UserName := 'sa';
  sDB_Database := 'GENERIC';
  sDB_Password := '';
  sDB_Protocol := 'mssql';
  sDB_Library := 'ntwdblib.dll';
  sDB_CtrlsCP := 'GET_ACP';
  sDB_ClientCP := 'WIN1250';

  sDictionaryFile := 'polish.lng';
  sSelectedLanguage := 'POLISH';
  sLangCode := 'pl';

  bDB_AutoEncodeStrings := true;
end;

procedure TConfig.Restore(fname : String);
var f : TIniFile;
    sEncrypted : String;
begin
  fname := Trim(fname);
  if Length(fname) < 1 then fname := Trim(sFile_Restore);
  if Length(fname) < 1 then raise Exception.Create('empty configuration file name');

  f := TIniFile.Create(fname);
  bHideStart := f.ReadBool('program', 'hide_start', bHideStart);
  sDeviceId := f.ReadString('program', 'device_id', sDeviceId);
  sLauncher_Path := f.ReadString('program', 'launcher_path', sLauncher_Path);
  sLauncher_Ini_Path := f.ReadString('program', 'launcher_ini', sLauncher_Ini_Path);
  bChangeAction := f.ReadBool('program', 'changeaction', bChangeAction);
  sDictionaryFile := f.ReadString('language', 'dictionaryfile', sDictionaryFile);
  sSelectedLanguage := f.ReadString('language', 'selected_language', sSelectedLanguage);
  sLangCode := f.ReadString('language','lang_code',sLangCode);

  ModDrukowanie := f.ReadBool('modules', 'mod_drukowanie', ModDrukowanie);

  sDB_Server   := f.ReadString('database','server'   ,sDB_Server);
  iDB_Port     := f.ReadInteger('database', 'port', iDB_Port);
  sDB_Database := f.ReadString('database','database' ,sDB_Database);
  sDB_UserName := f.ReadString('database','username' ,sDB_UserName);
  sEncrypted   := f.ReadString('database','password' ,'');
  sDB_Password := dsDecryptString(AppVersion.sCopyright, sEncrypted);
  sDB_Protocol := f.ReadString('database','protocol', sDB_Protocol);
  sDB_Library  := f.ReadString('database','library' , sDB_Library);
  bDB_AutoEncodeStrings := f.ReadBool('database','auto_encode_strings', bDB_AutoEncodeStrings);
  sDB_CtrlsCP  := f.ReadString('database','controls_codepage', sDB_CtrlsCP);
  sDB_ClientCP := f.ReadString('database','client_codepage', sDB_ClientCP);

  //_debug.loglx(L_INFO, 'PrimaSkory', 'TConfig', 'Restore.Read.LocalEcho');
  //_debug.bLocalEcho := f.ReadBool('debug','local_echo', false);
  sLogPath := f.ReadString('debug','log_path','.');
  iLevel := f.ReadInteger('debug','level',iLevel);
  iMaxSize := f.ReadInteger('debug','maxsize',iMaxSize);
  bDebugZeos := f.ReadBool('debug','debug_zeos', false);

  f.Free;


  sFile_Restore := fname;
end;

procedure TConfig.Store(fname : String);
var f : TIniFile;
    sEncrypted : String;
begin
  fname := Trim(fname);
  if Length(fname) < 1 then fname := Trim(sFile_Store);
  if Length(fname) < 1 then raise Exception.Create('empty configuration file name');

  f := TIniFile.Create(fname);

  f.WriteBool('program', 'hide_start', bHideStart);
  f.WriteBool('program', 'changeaction', bChangeAction);
  f.WriteString('program', 'launcher_path', sLauncher_Path);
  f.WriteString('program', 'launcher_ini', sLauncher_Ini_Path);

  f.WriteString('language', 'selected_language', sSelectedLanguage);
  f.WriteString('language','lang_code',sLangCode);

  f.WriteBool('modules', 'mod_drukowanie', ModDrukowanie);

  f.WriteString('database','server'  , sDB_Server);
  f.WriteInteger('database', 'port', iDB_Port);
  f.WriteString('database','database', sDB_Database);
  f.WriteString('database','username', sDB_UserName);
  sEncrypted := dsEncryptString(AppVersion.sCopyright, sDB_Password);
  f.WriteString('database','password', sEncrypted);
  f.WriteString('database','protocol', sDB_Protocol);
  f.WriteString('database','library' , sDB_Library);
  f.WriteBool('database','auto_encode_strings',bDB_AutoEncodeStrings);
  f.WriteString('database','controls_codepage',sDB_CtrlsCP);
  f.WriteString('database','client_codepage',sDB_ClientCP);

  f.WriteString('debug','log_path',sLogPath);
  f.WriteBool('debug','local_echo',_debug.bLocalEcho);
  f.WriteInteger('debug','level',_debug.level);
  f.WriteInteger('debug','maxsize',_debug.maxSize);
  f.WriteBool('debug','debug_zeos',bDebugZeos);

  f.Free;
  sFile_Store := fname;
end;

end.

