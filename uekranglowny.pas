unit uEkranGlowny;

{$mode delphi}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, DBCtrls, Buttons, Grids, Calendar, DateTimePicker, switches,
  rxdbgrid, rxswitch, rxclock, ZDataset, LCLType, uConfig, uMVRxDBGrid,
  character, Sockets, uDebug, uVersion;

type

  { TEkranGlowny }


  { TFormEkranGlowny }

  TFormEkranGlowny = class(TForm)
    BtnPgDownPozycje: TSpeedButton;
    BtnPgDownLista: TSpeedButton;
    BtnPgUpPozycje: TSpeedButton;
    BtnPgUpLista: TSpeedButton;
    BtnSkoraKoszerna: TSpeedButton;
    BtnSkoraZwykla: TSpeedButton;
    BtnStorno: TSpeedButton;
    BtnWyloguj: TSpeedButton;
    BtnZakonczNote: TSpeedButton;
    BtnZmianaWidoku: TSpeedButton;
    DSPozycjeNoty: TDataSource;
    DSListaWazen: TDataSource;
    GbPozycjeNoty: TGroupBox;
    GbListaWazen: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    LblVersion: TLabel;
    LblTrybTestowy: TLabel;
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
    Panel1: TPanel;
    PnlBackground: TPanel;
    PnlNames1: TPanel;
    PnlValues1: TPanel;
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
    RxListaWazen: TMVRxDBGrid;
    TbAkcje: TToolBar;
    ZListaWazenWAZ_NR_UBOJOWY: TLongintField;
    ZLoadSettings: TZReadOnlyQuery;
    ZLoadTempData: TZReadOnlyQuery;
    ZStatusWazenia: TZReadOnlyQuery;
    ZLoadTempVal: TZReadOnlyQuery;
    ZListaWazen: TZReadOnlyQuery;
    ZPozycjeNotyZLC_ILOSC_WAZEN: TLongintField;
    ZPozycjeNotyZLC_ILOSC_ZAMOWIONA_MAS: TFloatField;
    ZPozycjeNotyZLC_ILOSC_ZREALIZOWANA_MAS: TFloatField;
    ZPozycjeNotyZLC_KOD_ASORTYMENTU: TStringField;
    ZPozycjeNotyZLC_NAZWA_ASORTYMENTU: TStringField;
    ZStatusWazeniaVALUE: TStringField;
    ZStornoQuery: TZQuery;
    ZWazeniaWAZ_ID: TLongintField;
    ZWazeniaWAZ_INDEKS: TStringField;
    ZWazeniaWAZ_MASA: TFloatField;
    ZWazeniaWAZ_PARTIA: TStringField;
    ZZakonczNoteTempData: TZReadOnlyQuery;
    ZResetTempVal: TZReadOnlyQuery;
    ZLoadTempValID: TLongintField;
    ZLoadTempValID1: TLongintField;
    ZLoadTempValVALUE: TStringField;
    ZLoadTempValVALUE1: TStringField;
    ZPrintQuery: TZQuery;
    ZRodzajSkory: TZQuery;
    ZPozycjeNoty: TZReadOnlyQuery;
    ZScanCode: TZQuery;
    ZScanNote: TZQuery;
    procedure BtnZmianaWidokuClick(Sender: TObject);
    procedure BtnStornoClick(Sender: TObject);
    function PobierzMase(): Double;
    procedure BtnPgUpPozycjeClick(Sender: TObject);
    procedure BtnPgDownPozycjeClick(Sender: TObject);
    procedure BtnPgUpListaClick(Sender: TObject);
    procedure BtnPgDownListaClick(Sender: TObject);
    procedure BtnSkoraKoszernaClick(Sender: TObject);
    procedure BtnSkoraZwyklaClick(Sender: TObject);
    procedure BtnZakonczNoteClick(Sender: TObject);
    procedure GridPageDown(AGrid: TMVRxDBGrid);
    procedure GridPageUp(AGrid: TMVRxDBGrid);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnWylogujClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure WczytajNote();
    procedure SkanKodu();
    procedure SprawdzIndeks();
    procedure Print();
    procedure RefreshPnlValues();
    procedure RefreshGrd();
  private
    OprId: Integer;
    NumerNoty: String;
    KodWazenia: String;
    NotaWczytana: Boolean;
    SkoraKoszerna: Boolean;
    MasaHaka: Double;
    MasaZwazona: Double;
    WidokListyWazen: Boolean;
    StanSkanuKodu: String;
  public
    class function Execute(AOprId: Integer; AOprNazwa: String): Boolean;
  end;

var
  FormEkranGlowny: TFormEkranGlowny;

implementation

{ TFormEkranGlowny }

procedure TFormEkranGlowny.FormCreate(Sender: TObject);
begin
  PnlZeskanuj.Align := alClient;

  BoundsRect := Screen.MonitorFromWindow(Handle).BoundsRect;
  NumerNoty := '';
  NotaWczytana := False;
  KodWazenia := '';
  PnlZeskanuj.Visible := True;
  WidokListyWazen := False;
  BtnStorno.Enabled := false;
  BtnZmianaWidoku.Caption := 'Lista ważeń';
  LblVersion.Caption := 'Prima Skóry, Wersja ' + uVersion.AppVersion.sVersion;

  BtnSkoraZwyklaClick(Sender);
end;

procedure TFormEkranGlowny.FormKeyPress(Sender: TObject; var Key: char);
begin
  if NotaWczytana = True then
  begin
    if IsNumber(Key) = True then KodWazenia := KodWazenia + Key;
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
      _debug.loglx(L_INFO, 'EkranGlowny', 'FormKeyDown: Kod zeskanowany', KodWazenia);
      if Length(KodWazenia) <> 9 then
      begin
        ShowMessage('Niepoprawny kod!');
        _debug.loglx(L_INFO, 'EkranGlowny', 'FormKeyDown: Niepoprawny kod!', KodWazenia);
      end
      else
      begin
        MasaZwazona := PobierzMase();
        if MasaZwazona >0 then
        begin
          SkanKodu();
          RefreshPnlValues();
          SprawdzIndeks();
          if StanSkanuKodu = 'INDEKS_NULL' then
          begin
            PnlBackground.Color:=ClRed;
            _debug.loglx(L_INFO, 'EkranGlowny', 'FormKeyDown: Indeks nie istnieje!', '');
            ShowMessage('Indeks nie istnieje!')
          end
          else if StanSkanuKodu = 'INDEKS_NIE_NA_NOCIE' then
          begin
            PnlBackground.Color:=ClRed;
            _debug.loglx(L_INFO, 'EkranGlowny', 'FormKeyDown: Brak wybranego indeksu na nocie!', '');
            ShowMessage('Brak wybranego indeksu na nocie!')
          end
          else if StanSkanuKodu = 'BRAK' then
          begin
            PnlBackground.Color:=ClRed;
            _debug.loglx(L_INFO, 'EkranGlowny', 'FormKeyDown: Błąd weryfikacji indeksu! Zeskanuj ponownie.', '');
            ShowMessage('Błąd weryfikacji indeksu!')
          end
          else if StanSkanuKodu = 'OK' then
          begin
            PnlBackground.Color := ClDefault;
            Print();
          end;

          //RefreshPnlValues();
          //if Pos('Brak', LblIndeks.Caption) > 0 then
          //begin
          //  PnlBackground.Color:=ClRed;
          //  ShowMessage('Brak wybranego indeksu na nocie!');
          //  _debug.loglx(L_INFO, 'EkranGlowny', 'FormKeyDown: Brak wybranego indeksu na nocie!', '');
          //end
          //else
          //begin
          //  PnlBackground.Color := ClDefault;
          //  Print();
          //  RefreshPnlValues();
          //end;
        end;
      end;
      Key := 0;
      KodWazenia := '';
      RefreshPnlValues();
      RefreshGrd();
    end;
  end
  else begin
    if Key = VK_RETURN then
    begin
      _debug.loglx(L_INFO, 'EkranGlowny', 'FormKeyDown: Nota zeskanowana:', NumerNoty);
      if Length(NumerNoty) <> 10 then
      begin
        ShowMessage('Niepoprawny numer noty!');
        _debug.loglx(L_INFO, 'EkranGlowny', 'FormKeyDown: Niepoprawny numer noty!', NumerNoty);
        NumerNoty := '';
        Exit();
      end;
      Key := 0;
      WczytajNote();
      RefreshGrd();
    end;
  end;
end;

procedure TFormEkranGlowny.WczytajNote();
begin
  _debug.loglx(L_INFO, 'EkranGlowny', 'WczytajNote', 'Begin');
  ZScanNote.ParamByName('deviceid').Value := Config.sDeviceId;
  ZScanNote.ParamByName('code').Value := NumerNoty;

  ZScanNote.Open;
  if ZScanNote.FieldByName('RESULT').AsString = 'NOTA_FINISHED' then
  begin
    ShowMessage('Zeskanowana nota jest zakończona!');
    _debug.loglx(L_INFO, 'EkranGlowny', 'WczytajNote', 'Zeskanowana nota jest zakonczona!');
    Exit();
  end
  else if ZScanNote.FieldByName('RESULT').AsString = 'OK' then
  begin
    NotaWczytana := True;
    PnlZeskanuj.Visible := False;

    ZLoadSettings.ParamByName('deviceid').Value := Config.sDeviceId;
    ZLoadSettings.Open;
    MasaHaka := ZLoadSettings.FieldByName('MASA_HAKA').AsFloat;
    ZLoadSettings.Close;

    ZLoadTempData.ParamByName('deviceid').Value := Config.sDeviceId;
    ZLoadTempData.ParamByName('oprid').Value := OprId;
    ZLoadTempData.Open;
    ZLoadTempData.Close;

    BtnSkoraZwyklaClick(nil);
    RefreshPnlValues();
  end
  else ShowMessage(ZScanNote.FieldByName('RESULT').AsString);
  ZScanNote.Close;
  _debug.loglx(L_INFO, 'EkranGlowny', 'WczytajNote', 'End');
end;

procedure TFormEkranGlowny.SkanKodu();
begin
  _debug.loglx(L_INFO, 'EkranGlowny', 'SkanKodu', 'Begin');
  ZScanCode.ParamByName('deviceid').Value := Config.sDeviceId;
  ZScanCode.ParamByName('code').Value := KodWazenia;
  ZScanCode.ParamByName('masa').Value := MasaZwazona;
  ZScanCode.ExecSQL;
  _debug.loglx(L_INFO, 'EkranGlowny', 'SkanKodu', 'End');
end;

procedure TFormEkranGlowny.SprawdzIndeks();
begin
  _debug.loglx(L_INFO, 'EkranGlowny', 'SprawdzIndeks', 'Begin');
  ZStatusWazenia.ParamByName('deviceid').Value := Config.sDeviceId;
  ZStatusWazenia.Open;
  StanSkanuKodu := ZStatusWazeniaVALUE.AsString;
  ZStatusWazenia.Close;
  _debug.loglx(L_INFO, 'EkranGlowny', 'SprawdzIndeks', 'End');
end;

procedure TFormEkranGlowny.Print();
begin
  _debug.loglx(L_INFO, 'EkranGlowny', 'Print', 'Begin');
  ZPrintQuery.ParamByName('deviceid').Value := Config.sDeviceId;
  ZPrintQuery.ParamByName('masa').Value := MasaZwazona;
  ZPrintQuery.ExecSQL;
  _debug.loglx(L_INFO, 'EkranGlowny', 'Print', 'End');
end;

procedure TFormEkranGlowny.RefreshPnlValues();
begin
  _debug.loglx(L_INFO, 'EkranGlowny', 'RefreshPanelValues', 'Begin');
  ZLoadTempVal.Close;
  ZLoadTempVal.ParamByName('deviceid').Value := Config.sDeviceId;
    ZLoadTempVal.Open;

    while not ZLoadTempVal.EOF do begin
      case ZLoadTempValID.Value of
        1: LblNumerUbojowy.Caption := ZLoadTempValVALUE.AsString;
        2: LblDataUboju.Caption := ZLoadTempValVALUE.AsString;
        4: LblNumerNoty.Caption := ZLoadTempValVALUE.AsString;
        5: LblIndeks.Caption := ZLoadTempValVALUE.AsString;
        6: LblTowar.Caption := ZLoadTempValVALUE.AsString;
        7: LblOdbiorca.Caption := ZLoadTempValVALUE.AsString;
        10: LblSamochod.Caption := ZLoadTempValVALUE.AsString;
        11: LblIloscPoz.Caption := ZLoadTempValVALUE.AsString;
        12: LblIloscNoty.Caption := ZLoadTempValVALUE.AsString;
      end;
      ZLoadTempVal.Next;
    end;
    ZLoadTempVal.Close;
    _debug.loglx(L_INFO, 'EkranGlowny', 'RefreshPanelValues', 'End');
end;

procedure TFormEkranGlowny.RefreshGrd();
begin
  _debug.loglx(L_INFO, 'EkranGlowny', 'RefreshGrd', 'Begin');
  ZPozycjeNoty.Close;
  ZPozycjeNoty.ParamByName('deviceid').Value := Config.sDeviceId;
  ZPozycjeNoty.Open;
  BtnPgUpPozycje.Enabled:=(ZPozycjeNoty.RecordCount>6);
  BtnPgDownPozycje.Enabled:=(ZPozycjeNoty.RecordCount>6);

  ZListaWazen.Close;
  ZListaWazen.ParamByName('deviceid').Value := Config.sDeviceId;
  ZListaWazen.Open;
  BtnPgUpLista.Enabled:=(ZListaWazen.RecordCount>5);
  BtnPgDownLista.Enabled:=(ZListaWazen.RecordCount>5);
    _debug.loglx(L_INFO, 'EkranGlowny', 'RefreshGrd', 'End');
end;

procedure TFormEkranGlowny.BtnWylogujClick(Sender: TObject);
begin
  if NotaWczytana = True then
  begin
    BtnZakonczNoteClick(Sender);
  end;
  _debug.loglx(L_INFO, 'EkranGlowny', 'BtnWylogujClick', 'Wylogowanie');
  Close;
end;

procedure TFormEkranGlowny.BtnZakonczNoteClick(Sender: TObject);
begin
  _debug.loglx(L_INFO, 'EkranGlowny', 'BtnZakonczNoteClick', 'Begin');
  NumerNoty := '';
  NotaWczytana := False;
  KodWazenia := '';
  PnlZeskanuj.Visible := True;
  BtnSkoraZwyklaClick(Sender);

  ZResetTempVal.ExecSQL;
  ZZakonczNoteTempData.ExecSQL;
  LblNumerUbojowy.Caption := ' ';
  LblDataUboju.Caption := ' ';
  LblNumerNoty.Caption := ' ';
  LblIndeks.Caption := ' ';
  LblTowar.Caption := ' ';
  LblOdbiorca.Caption := ' ';
  LblSamochod.Caption := ' ';
  LblIloscPoz.Caption := ' ';
  LblIloscNoty.Caption := ' ';
  _debug.loglx(L_INFO, 'EkranGlowny', 'BtnZakonczNoteClick', 'End');
end;

procedure TFormEkranGlowny.BtnSkoraZwyklaClick(Sender: TObject);
begin
  SkoraKoszerna := False;
  BtnSkoraZwykla.Color := $00A37C58;
  BtnSkoraKoszerna.Color := $00EBCCAF;
  if NotaWczytana = True then
  begin
    ZRodzajSkory.ParamByName('deviceid').Value := Config.sDeviceId;
    ZRodzajSkory.ParamByName('rodzaj').Value := 1;
    ZRodzajSkory.ExecSQL;
  end;
end;

procedure TFormEkranGlowny.BtnSkoraKoszernaClick(Sender: TObject);
begin
  SkoraKoszerna := True;
  BtnSkoraZwykla.Color := $00EBCCAF;
  BtnSkoraKoszerna.Color := $00A37C58;
  ZRodzajSkory.ParamByName('deviceid').Value := Config.sDeviceId;
  ZRodzajSkory.ParamByName('rodzaj').Value := 2;
  ZRodzajSkory.ExecSQL;
end;

function TFormEkranGlowny.PobierzMase(): Double;
var
  ClientSocket: TSocket;
  ServerAddr: TInetSockAddr;
  Data: string;
  BytesSent, BytesReceived, BytesReceived2: Integer;
  Buffer: array[0..511] of Char;
  Buffer2: array[0..511] of Char;
  WeightString: String;
  Weight: Double;

begin
  if config.bTrybTestowy = True then
  begin
    Result := 72.44;
    Exit;
  end;
  _debug.loglx(L_INFO, 'EkranGlowny', 'PobierzMase', 'Begin');
  // Create socket
  ClientSocket := fpSocket(AF_INET, SOCK_STREAM, 0);

  // Set up server address
  FillChar(ServerAddr, SizeOf(ServerAddr), 0);
  ServerAddr.sin_family := AF_INET;
  ServerAddr.sin_port := htons(4001);
  ServerAddr.sin_addr.s_addr := htonl(StrToHostAddr(Config.sWskaznikIp).s_addr);

  // Connect to server
  if fpConnect(ClientSocket, @ServerAddr, SizeOf(ServerAddr)) <> 0 then
  begin
    _debug.loglx(L_INFO, 'EkranGlowny', 'PobierzMase', 'Błąd połączenia ze wskaźnikiem!');
    ShowMessage('Błąd połączenia ze wskaźnikiem!');
;
    Exit;
  end;

  // Send data
  Data := 'S ' + #13#10;
  BytesSent := fpSend(ClientSocket, PChar(Data), Length(Data), 0);
  if BytesSent < 0 then
  begin
    _debug.loglx(L_INFO, 'EkranGlowny', 'PobierzMase', 'Błąd odpytytania wskaźnika!');
    ShowMessage('Błąd odpytywania wskaźnika!');
    Exit;
  end;

  // Receive ack
  BytesReceived := fpRecv(ClientSocket, @Buffer, SizeOf(Buffer), 0);
  if BytesReceived < 0 then
  begin
    _debug.loglx(L_INFO, 'EkranGlowny', 'PobierzMase', 'Błąd odczytu danych (1) ze wskaźnika');
    ShowMessage('Błąd odczytu danych (1) z wskaźnika!');
    Exit;
  end
  else
  begin
    Buffer[BytesReceived] := #0;
  end;

  // Receive response 1
  BytesReceived2 := fpRecv(ClientSocket, @Buffer2, SizeOf(Buffer), 0);
  if BytesReceived2 < 0 then
  begin
    _debug.loglx(L_INFO, 'EkranGlowny', 'PobierzMase', 'Błąd odczytu danych (2) ze wskaźnika');
    ShowMessage('Błąd odczytu danych (2) z wskaźnika!');
    Exit;
  end
  else
  begin
    Buffer[BytesReceived2] := #0;
  end;

  // Close socket
  CloseSocket(ClientSocket);

  _debug.loglx(L_INFO, 'EkranGlowny', 'PobierzMase recived:', Trim(Buffer2));
  if Pos('kg', Buffer2) > 0 then
  begin


    WeightString := (Trim(Copy(Buffer2, 4, 12)));
    _debug.loglx(L_INFO, 'EkranGlowny', 'PobierzMase cut:', Trim(WeightString));

    WeightString := StringReplace(WeightString, 'kg', '', [rfReplaceAll, rfIgnoreCase]);
        WeightString := StringReplace(WeightString, ' ', '', [rfReplaceAll, rfIgnoreCase]);
            WeightString := StringReplace(WeightString, '.', ',', [rfReplaceAll, rfIgnoreCase]);
    if WeightString = '0.0' then ShowMessage('Brak skóry na wadze!');
    Weight := StrToFloat(WeightString);
    Weight := Weight - MasaHaka;

    Result := Weight;
  end
  else
  begin
    ShowMessage('Otrzymano niepoprawne dane ze wskaźnika!');
    Result := 0;
  end;
  _debug.loglx(L_INFO, 'EkranGlowny', 'PobierzMase', 'End');
end;

procedure TFormEkranGlowny.BtnStornoClick(Sender: TObject);
begin
  if ZWazeniaWAZ_ID.AsInteger > 0 then
  begin
    if Application.MessageBox(PChar('Czy na pewno zestornować pozycję'
      +IntToStr(ZWazeniaWAZ_ID.AsInteger)+' ?'),
      PChar(Caption), MB_YESNO or MB_ICONQUESTION) <> IDYES then exit;
    ZStornoQuery.ParamByName('deviceid').Value := Config.sDeviceId;
    ZStornoQuery.ParamByName('wazid').Value := ZWazeniaWAZ_ID.AsInteger;
    ZStornoQuery.ExecSQL;
    RefreshGrd();
  end
  else
  begin
    ShowMessage('Wybierz ważenie do stornowania!')
  end;
end;

procedure TFormEkranGlowny.BtnZmianaWidokuClick(Sender: TObject);
begin
  if WidokListyWazen = true then
  begin
    WidokListyWazen := false;
    BtnStorno.Enabled := false;
    BtnZmianaWidoku.Caption := 'Lista ważeń';
    GbListaWazen.Visible := false;
  end
  else
  begin
    WidokListyWazen := true;
    BtnStorno.Enabled := true;
    BtnZmianaWidoku.Caption := 'Pozycje noty';
    GbListaWazen.Visible := true;
  end;
end;

procedure TFormEkranGlowny.BtnPgUpPozycjeClick(Sender: TObject);
begin
  GridPageUp(RxPozycjeNoty);
end;

procedure TFormEkranGlowny.BtnPgDownPozycjeClick(Sender: TObject);
begin
  GridPageDown(RxPozycjeNoty);
end;

procedure TFormEkranGlowny.BtnPgUpListaClick(Sender: TObject);
begin
  GridPageUp(RxListaWazen);
end;

procedure TFormEkranGlowny.BtnPgDownListaClick(Sender: TObject);
begin
  GridPageDown(RxListaWazen);
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

class function TFormEkranGlowny.Execute(AOprId: Integer; AOprNazwa: String): Boolean;
var
  Form : TFormEkranGlowny;
begin
  Form := TFormEkranGlowny.Create(Application);
  Form.OprId := AOprId;
  Form.Label1.Caption := 'Zalogowany jako: ' + AOprNazwa + ', ' + IntToStr(AOprId);
   if config.bTrybTestowy = True then
  begin
    Form.LblTrybTestowy.Visible := true;
    Form.WindowState:=wsNormal;
    Form.BorderStyle := bsSizeable;
  end else
  begin
    Form.LblTrybTestowy.Visible := false;
    Form.WindowState := wsFullScreen;

  end;
  _debug.loglx(L_INFO, 'EkranGlowny', 'Execute', 'Create form');
  Form.ShowModal;
  Result := True;
  Form.Free;
end;



{$R *.lfm}

end.

