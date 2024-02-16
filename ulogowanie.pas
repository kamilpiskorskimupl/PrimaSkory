unit uLogowanie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  uMVRxDBGrid, ZDataset, DBGrids, Buttons, uEkranGlowny;

type

  { TFormLogowanie }

  TFormLogowanie = class(TForm)
    BtnRightPgDown: TSpeedButton;
    BtnRightPgUp: TSpeedButton;
    BtnZaloguj: TButton;
    DSLiteraList: TDataSource;
    DSLoginList: TDataSource;
    GbLeft: TGroupBox;
    GbRight: TGroupBox;
    RxLiteraList: TMVRxDBGrid;
    RxLoginList: TMVRxDBGrid;
    PnlFrame: TPanel;
    PnlLeft: TPanel;
    PnlRight: TPanel;
    Panel4: TPanel;
    BtnLeftPgUp: TSpeedButton;
    BtnLeftPgDown: TSpeedButton;
    ZLiteraList: TZReadOnlyQuery;
    ZLoginList: TZReadOnlyQuery;
    ZLiteraListOPR_LITERA: TStringField;
    ZLoginListOPR_ID: TLongintField;
    ZLoginListOPR_NAZWA: TStringField;
    procedure BtnLeftPgDownClick(Sender: TObject);
    procedure BtnRightPgDownClick(Sender: TObject);
    procedure BtnRightPgUpClick(Sender: TObject);
    procedure BtnLeftPgUpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure GridPageUp(AGrid: TMVRxDBGrid);
    procedure GridPageDown(AGrid: TMVRxDBGrid);
    procedure BtnZalogujClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RxLiteraListCellClick(Column: TColumn);
    procedure RxLoginListDblClick(Sender: TObject);
  private
    OprId: Integer;
    OprNazwa: String;
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
  RxLiteraList.DefaultRowHeight:=trunc(RxLiteraList.Height/10);
  RxLoginList.DefaultRowHeight:=trunc(RxLoginList.Height/10);
  BtnLeftPgUp.Enabled:=(ZLiteraList.RecordCount>10);
  BtnLeftPgDown.Enabled:=(ZLiteraList.RecordCount>10);
end;

procedure TFormLogowanie.FormDestroy(Sender: TObject);
begin

end;

procedure TFormLogowanie.BtnLeftPgUpClick(Sender: TObject);
begin
  GridPageUp(RxLiteraList);
  RxLiteraListCellClick(RxLiteraList.SelectedColumn);
end;

procedure TFormLogowanie.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  ZLiteraList.Close;
  ZLoginList.Close;
end;

procedure TFormLogowanie.BtnLeftPgDownClick(Sender: TObject);
begin
  GridPageDown(RxLiteraList);
  RxLiteraListCellClick(RxLiteraList.SelectedColumn);
end;

procedure TFormLogowanie.BtnRightPgUpClick(Sender: TObject);
begin
  GridPageUp(RxLoginList);
end;

procedure TFormLogowanie.BtnRightPgDownClick(Sender: TObject);
begin
  GridPageDown(RxLoginList);
end;

procedure TFormLogowanie.GridPageUp(AGrid: TMVRxDBGrid);
var
  RozmiarStrony : Integer;
  DataSet : TDataSet;
begin
  RozmiarStrony := AGrid.Height div AGrid.DefaultRowHeight;
  DataSet := AGrid.DataSource.DataSet;
  DataSet.RecNo := DataSet.RecNo - RozmiarStrony;
end;

procedure TFormLogowanie.GridPageDown(AGrid: TMVRxDBGrid);
var
  RozmiarStrony : Integer;
  DataSet : TDataSet;
begin
  RozmiarStrony := AGrid.Height div AGrid.DefaultRowHeight;
  DataSet := AGrid.DataSource.DataSet;
  DataSet.RecNo := DataSet.RecNo + RozmiarStrony;
end;

procedure TFormLogowanie.BtnZalogujClick(Sender: TObject);
begin
  OprId := ZLoginListOPR_ID.AsInteger;
  if OprId<1 then ShowMessage('Proszę wybrać operatora!')
  else begin
    OprNazwa := ZLoginListOPR_NAZWA.AsString;
    TFormEkranGlowny.Execute(OprId, OprNazwa);
  end;
end;

procedure TFormLogowanie.RxLiteraListCellClick(Column: TColumn);
begin
 ZLoginList.ParamByName('LITERA').Value:= RxLiteraList.SelectedField.Text;
 ZLoginList.Close;
 ZLoginList.Open;
 BtnRightPgUp.Enabled:=(ZLoginList.RecordCount>10);
 BtnRightPgDown.Enabled:=(ZLoginList.RecordCount>10);
end;

procedure TFormLogowanie.RxLoginListDblClick(Sender: TObject);
begin
  OprId := ZLoginListOPR_ID.AsInteger;
  OprNazwa := ZLoginListOPR_NAZWA.AsString;
  TFormEkranGlowny.Execute(OprId, OprNazwa)
end;


end.

