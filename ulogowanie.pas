unit uLogowanie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  uMVRxDBGrid, ZDataset, DBGrids;

type

  { TFormLogowanie }

  TFormLogowanie = class(TForm)
    DSLiteraList: TDataSource;
    DSLoginList: TDataSource;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    RxLiteraList: TMVRxDBGrid;
    RxLoginList: TMVRxDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    ZLiteraList: TZReadOnlyQuery;
    ZLoginList: TZReadOnlyQuery;
    ZLiteraListOPR_LITERA: TStringField;
    ZLoginListOPR_IMIE: TStringField;
    ZLoginListOPR_NAZWISKO: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RxLiteraListCellClick(Column: TColumn);
    procedure ZLiteraListOPR_LITERAChange(Sender: TField);
  private

  public

  end;

var
  FormLogowanie: TFormLogowanie;

implementation

{$R *.lfm}

{ TFormLogowanie }

procedure TFormLogowanie.FormCreate(Sender: TObject);
begin
  ZLiteraList.Open;
end;

procedure TFormLogowanie.FormDestroy(Sender: TObject);
begin
  ZLiteraList.Close;
  ZLoginList.Close;
end;


procedure TFormLogowanie.RxLiteraListCellClick(Column: TColumn);
begin
 ZLoginList.ParamByName('LITERA').Value:= RxLiteraList.SelectedField.Text;
 ZLoginList.Close;
 ZLoginList.Open;
 ZLoginList.Refresh;
end;

procedure TFormLogowanie.ZLiteraListOPR_LITERAChange(Sender: TField);
begin

end;

end.

