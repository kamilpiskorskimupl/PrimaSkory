program PrimaSkory;

{$mode objfpc}{$H+}
{$define UseCThreads}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, zcomponent, uLogowanie, uConfig, uversion,
  uCommons, LCLType, uDebug, rxnew
  { you can add units after this };

{$R *.res}

procedure Initialize;
begin
  LoadConfig;

  Commons := TCommons.Create(nil);
end;

procedure RunApplication;
begin
  _debug.loglx(L_INFO, 'PrimaSkory', 'RunApplication', 'Connect to database WYSYLKA.');
  Commons.DbWysylka.Connect;
  Commons.ZQueryANSI.ExecSQL;

  FormLogowanie := TFormLogowanie.Create(Application);
  FormLogowanie.Show();
  Application.Run
end;

procedure Finalize;
begin
  _debug.loglx(L_INFO, 'PrimaSkory', 'Initialize', 'Disconnect from database WYSYLKA.');
  Commons.DbWysylka.Disconnect;
  _debug.loglx(L_INFO, 'PrimaSkory', 'Finalize', 'Destroy Commons.');
  Commons.Free;
end;

var
  GlobalLogDirectory : String;

begin
  RequireDerivedFormResource:=True;
  Application.Title:='PrimaSkory';
  Application.Scaled:=True;
  Application.Initialize;
  Initialize;
  TLog.InitializeGlobalLog(Config.sLogPath);
  _debug.level := Config.iLevel;
  _debug.maxSize := Config.iMaxSize;
  RunApplication;
  Finalize;
  _debug.loglx(L_INFO, 'PrimaSkory', 'Program', '*** END. ***');
end.
