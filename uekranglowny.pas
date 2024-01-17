unit uEkranGlowny;

{$mode delphi}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, DBCtrls, Buttons, Grids, Calendar, DateTimePicker, switches,
  rxdbgrid, rxswitch, rxclock, uGxDateField, ZDataset, LCLType;

type

  { TEkranGlowny }


  { TFormEkranGlowny }

  TFormEkranGlowny = class(TForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
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
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    TbAkcje: TToolBar;
    ZDaneNoty: TZReadOnlyQuery;
    ZDaneNotyNTN_NAZWA1: TStringField;
    ZZestawienie: TZQuery;
    ZZestawienieLMW_ADRES: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnWylogujClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure WczytajNote();
  private
    OprId: Integer;
    NumerNoty: String;
    NotaWczytana: Boolean;
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
  PnlZeskanuj.Visible := True;
  //ZZestawienie.Open;
end;

procedure TFormEkranGlowny.FormDestroy(Sender: TObject);
begin
  //ZZestawienie.Close;
end;

procedure TFormEkranGlowny.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if NotaWczytana = False then
  begin
    if Key = VK_RETURN then
    begin
      WczytajNote();
      NotaWczytana := True;
      PnlZeskanuj.Visible := False;
    end;
  end;
end;

procedure TFormEkranGlowny.WczytajNote();
begin
  ZDaneNoty.ParamByName('numernoty').Value := NumerNoty;
  ZDaneNoty.Close;
  ZDaneNoty.Open;
  LblNumerNoty.Caption := NumerNoty;
  LblOdbiorca.Caption := ZDaneNotyNTN_NAZWA1.Value;
//  LblOdbiorca :=
end;

procedure TFormEkranGlowny.BtnWylogujClick(Sender: TObject);
begin
  Close;
end;

procedure TFormEkranGlowny.FormKeyPress(Sender: TObject; var Key: char);
begin
  //if NotaWczytana = False then
  begin
    //if (Key = VK_RETURN) then
    //begin
    //  WczytajNote();
    //  NotaWczytana := True;
    //  PnlZeskanuj.Visible := False;
    //end;
    NumerNoty := NumerNoty + Key;
    LblTowar.Caption := Key;
    LblIloscPoz.Caption := NumerNoty;
  end;
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

