unit uLogowanie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  uMVRxDBGrid, ZDataset, DBGrids, Buttons, uEkranGlowny;

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
    BtnZaloguj: TSpeedButton;
    ZLiteraList: TZReadOnlyQuery;
    ZLoginList: TZReadOnlyQuery;
    ZLiteraListOPR_LITERA: TStringField;
    ZLoginListOPR_ID: TLongintField;
    ZLoginListOPR_NAZWA: TStringField;
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

procedure TFormLogowanie.RxLoginListDblClick(Sender: TObject);
begin
  OprId := ZLoginListOPR_ID.AsInteger;
  OprNazwa := ZLoginListOPR_NAZWA.AsString;
  TFormEkranGlowny.Execute(OprId, OprNazwa)
end;

end.

