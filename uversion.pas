unit uVersion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type TAppVersion = record
  sProduct,
  sVersion,
  sFileVersion,
  sDate,
  sManufacturer,
  sUser,
  sCopyright : String;
end;

function GetAppVersion : String;
function GetAppCaption : String;

const
  AppVersion : TAppVersion =
  ( sProduct      : 'Prima Skóry';
    sVersion      : '1.2.0'; //Major.Minor.Patch
    sFileVersion  : '1';
    sDate         : {$I %DATE%};
    sManufacturer : 'Multivac sp. z o.o.';
    sUser         : {$I %USERNAME%};
    sCopyright    : '© Multivac sp. z o. o.'; );

implementation

function GetAppVersion : String;
var s : String;
begin
 s := 'Wersja aplikacji:' + #13+#10;
 s := s + ' Produkt: ' + AppVersion.sProduct + #13+#10;
 s := s + ' Wersja: ' + AppVersion.sVersion + #13+#10;
 s := s + ' Wersja pliku: ' + AppVersion.sFileVersion + #13+#10;
 s := s + ' Data: ' + AppVersion.sDate + #13+#10;
 s := s + ' Producent: ' + AppVersion.sManufacturer + #13+#10;
 s := s + ' Prawa autorskie: ' + AppVersion.sCopyright + #13+#10;
 GetAppVersion := s;
end;

function GetAppCaption : String;
begin
 Result := Format(
   '%s %s %s',
   [AppVersion.sProduct, AppVersion.sVersion, AppVersion.sCopyright]);
end;

end.

