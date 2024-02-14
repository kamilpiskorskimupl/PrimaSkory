unit uCommons;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset, uconfig, LazUTF8, udebug;

type

  { TCommons }

  TCommons = class(TDataModule)
    DbWysylka: TZConnection;
    ZQueryANSI: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
  end;

var
  Commons: TCommons;

implementation

{$R *.lfm}

{ TCommons }

procedure TCommons.DataModuleCreate(Sender: TObject);
begin
  DbWysylka.HostName := Config.sDB_Server;
  DbWysylka.Port := Config.iDB_Port;
  DbWysylka.Protocol := Config.sDB_Protocol;
  DbWysylka.LibraryLocation := Config.sDB_Library;
  DbWysylka.ClientCodepage := Config.sDB_ClientCP;
  DbWysylka.AutoEncodeStrings := Config.bDB_AutoEncodeStrings;
  DbWysylka.User := Config.sDB_UserName;
  DbWysylka.Password := Config.sDB_Password;
end;

end.

