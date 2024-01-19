unit uEkranGlowny;

{$mode delphi}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, DBCtrls, Buttons, Grids, Calendar, DateTimePicker, switches,
  rxdbgrid, rxswitch, rxclock, ZDataset, LCLType, uConfig, uMVRxDBGrid;

type

  { TEkranGlowny }


  { TFormEkranGlowny }

  TFormEkranGlowny = class(TForm)
    BtnPgDown: TSpeedButton;
    BtnPgUp: TSpeedButton;
    BtnSkoraKoszerna: TButton;
    BtnSkoraZwykla: TButton;
    CbWazenieAutomatyczne: TCheckBox;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    GbPozycjeNoty: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    LblNumerNoty: TLabel;
    LblOdbiorca: TLabel;
    LblSamochod: TLabel;
    LblIloscNoty: TLabel;
    LblNumerUbojowy: TLabel;
    LblDataUboju: TLabel;
    LblIndeks: TLabel;
    Label2: TLabel;
    LblTowar: TLabel;
    LblIloscPoz: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RadioGroup1: TGroupBox;
    RxPozycjeNoty: TMVRxDBGrid;
    PnlZeskanuj: TPanel;
    PnlClock: TPanel;
    PnlWazenia: TPanel;
    PnlWazeniaButtons: TPanel;
    PnlFrame: TPanel;
    PnlBottomStatus: TPanel;
    PnlMain: TPanel;
    PnlNames: TPanel;
    PnlRight: TPanel;
    PnlValues: TPanel;
    PnlLeft: TPanel;
    PnlDaneButtons: TPanel;
    PnlTools: TPanel;
    RxClock1: TRxClock;
    RxDBGrid1: TRxDBGrid;
    BtnWyloguj: TSpeedButton;
    BtnStorno: TSpeedButton;
    BtnDrukujPonownie: TSpeedButton;
    BtnZakonczNote: TSpeedButton;
    BtnWazenie: TSpeedButton;
    TbAkcje: TToolBar;
    ZDaneNoty: TZReadOnlyQuery;
    ZScanCode: TZQuery;
    ZStanNoty: TZReadOnlyQuery;
    ZDaneNotyNTN_NAZWA1: TStringField;
    ZScanNote: TZQuery;
    ZStanNotyNOT_INDNAZWA: TStringField;
    ZStanNotyNOT_ZAMOWIONE: TStringField;
    ZZestawienie: TZQuery;
    ZZestawienieLMW_ADRES: TStringField;
    procedure BtnPgUpClick(Sender: TObject);
    procedure BtnPgDownClick(Sender: TObject);
    procedure BtnSkoraKoszernaClick(Sender: TObject);
    procedure BtnSkoraZwyklaClick(Sender: TObject);
    procedure GridPageDown(AGrid: TMVRxDBGrid);
    procedure GridPageUp(AGrid: TMVRxDBGrid);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnWylogujClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure WczytajNote();
    procedure DodajWazenie();
  private
    OprId: Integer;
    NumerNoty: String;
    KodWazenia: String;
    NotaWczytana: Boolean;
    SkoraKoszerna: Boolean;
  public
    class function Execute(AOprId: Integer; AOprNazwa: String): Boolean;
  end;

var
  FormEkranGlowny: TFormEkranGlowny;

implementation

{ TFormEkranGlowny }

procedure TFormEkranGlowny.FormCreate(Sender: TObject);
begin
  NumerNoty := '';
  NotaWczytana := False;
  KodWazenia := '';
  PnlZeskanuj.Visible := True;
  BtnSkoraZwykla.Color := clBtnShadow;
  SkoraKoszerna := False;
  BtnDrukujPonownie.Enabled:= Config.ModDrukowanie;
end;

procedure TFormEkranGlowny.FormDestroy(Sender: TObject);
begin
  //ZZestawienie.Close;
end;

procedure TFormEkranGlowny.FormKeyPress(Sender: TObject; var Key: char);
begin
  if NotaWczytana = True then
  begin
    KodWazenia := KodWazenia + Key;
  end
  else begin
    NumerNoty := NumerNoty + Key;
  end;
end;

procedure TFormEkranGlowny.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if NotaWczytana = True then
  begin
    if Key = VK_RETURN then
    begin
      DodajWazenie();
      KodWazenia := '';
    end;
  end
  else begin
    if Key = VK_RETURN then
    begin
      WczytajNote();
    end;
  end;
end;

procedure TFormEkranGlowny.WczytajNote();
begin
  //ZDaneNoty.ParamByName('numernoty').Value := NumerNoty;
  //ZDaneNoty.Close;
  //ZDaneNoty.Open;


  ZScanNote.ParamByName('deviceid').Value := Config.sDeviceId;
  ZScanNote.ParamByName('code').Value := NumerNoty;

  ZScanNote.Open;
  LblIndeks.Caption := ZScanNote.FieldByName('RESULT').AsString;

  if ZScanNote.FieldByName('RESULT').AsString = 'NOTA_FINISHED' then
  begin
    ShowMessage('Zeskanowana nota jest zakończona!');
    Exit();
  end
  else if ZScanNote.FieldByName('RESULT').AsString = 'OK' then
  begin
    NotaWczytana := True;
    PnlZeskanuj.Visible := False;
    LblNumerNoty.Caption := NumerNoty;
    //LblOdbiorca.Caption := ZScanNote.FieldByName('NOT_INDNAZWA').AsString;
    //LblIloscNoty.Caption := ZScanNote.FieldByName('NOT_ZAMOWIONE').AsString;

    ZStanNoty.ParamByName('code').Value := NumerNoty;
    ZStanNoty.Open;

    LblTowar.Caption := ZStanNoty.FieldByName('NOT_INDNAZWA').AsString;
    LblIloscNoty.Caption := ZStanNoty.FieldByName('NOT_ZAMOWIONE').AsString;

  end;

end;

procedure TFormEkranGlowny.DodajWazenie();
begin
  ZDaneNoty.ParamByName('numernoty').Value := NumerNoty;
  ZDaneNoty.Close;
  ZDaneNoty.Open;
  //LblNumerNoty.Caption := NumerNoty;
  //LblOdbiorca.Caption := ZDaneNotyNTN_NAZWA1.Value;

  //BtnPgUp.Enabled:=(ZLoginList.RecordCount>10);
  //BtnPgDown.Enabled:=(ZLoginList.RecordCount>10);

  ZDaneNoty.ParamByName('numernoty').Value := NumerNoty;


end;

procedure TFormEkranGlowny.BtnPgUpClick(Sender: TObject);
begin
  GridPageUp(RxPozycjeNoty);
end;

procedure TFormEkranGlowny.BtnPgDownClick(Sender: TObject);
begin
  GridPageDown(RxPozycjeNoty);
end;

procedure TFormEkranGlowny.BtnSkoraZwyklaClick(Sender: TObject);
begin
  SkoraKoszerna := False;
  BtnSkoraZwykla.Color := clBtnShadow;
  BtnSkoraKoszerna.Color := clDefault;
end;

procedure TFormEkranGlowny.BtnSkoraKoszernaClick(Sender: TObject);
begin
  SkoraKoszerna := True;
  BtnSkoraZwykla.Color := clDefault;
  BtnSkoraKoszerna.Color := clBtnShadow;
end;

procedure TFormEkranGlowny.GridPageUp(AGrid: TMVRxDBGrid);
var
  RozmiarStrony : Integer;
  DataSet : TDataSet;
begin
  RozmiarStrony := AGrid.Height div AGrid.DefaultRowHeight;
  DataSet := AGrid.DataSource.DataSet;
  DataSet.RecNo := DataSet.RecNo - RozmiarStrony;
end;

procedure TFormEkranGlowny.GridPageDown(AGrid: TMVRxDBGrid);
var
  RozmiarStrony : Integer;
  DataSet : TDataSet;
begin
  RozmiarStrony := AGrid.Height div AGrid.DefaultRowHeight;
  DataSet := AGrid.DataSource.DataSet;
  DataSet.RecNo := DataSet.RecNo + RozmiarStrony;
end;

procedure TFormEkranGlowny.BtnWylogujClick(Sender: TObject);
begin
  Close;
end;

class function TFormEkranGlowny.Execute(AOprId: Integer; AOprNazwa: String): Boolean;
var
  Form : TFormEkranGlowny;
begin
  Form := TFormEkranGlowny.Create(Application);
  Form.OprId := AOprId;
  Form.Label1.Caption := 'Zalogowany jako: ' + AOprNazwa + ', ' + IntToStr(AOprId);
  Form.ShowModal;
  Result := True;
  Form.Free;
end;



{$R *.lfm}

end.

