unit uEkranGlowny;

{$mode delphi}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, DBCtrls, Buttons, rxdbgrid, ZDataset;

type

  { TEkranGlowny }


  { TFormEkranGlowny }

  TFormEkranGlowny = class(TForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    PnlMain: TPanel;
    PnlTools: TPanel;
    RxDBGrid1: TRxDBGrid;
    SpeedButton1: TSpeedButton;
    TbAkcje: TToolBar;
    ZZestawienie: TZQuery;
    ZZestawienieLMW_ADRES: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
  private
    OprId: Integer;
  public
    class function Execute(AOprId: Integer; AOprNazwa: String): Boolean;
  end;

var
  FormEkranGlowny: TFormEkranGlowny;

implementation

{ TFormEkranGlowny }

procedure TFormEkranGlowny.FormCreate(Sender: TObject);
begin
  //ZZestawienie.Open;
end;

procedure TFormEkranGlowny.FormDestroy(Sender: TObject);
begin
  //ZZestawienie.Close;
end;

procedure TFormEkranGlowny.Panel1Click(Sender: TObject);
begin
   Panel2.Caption := IntToStr(OprId);
end;

procedure TFormEkranGlowny.Panel3Click(Sender: TObject);
begin

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

