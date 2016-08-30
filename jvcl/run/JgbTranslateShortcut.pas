{-----------------------------------------------------------------------------
 Unit Name: JgbTranslateShortcut
 Author:    Jacob Boerema
 Created:   2014-08-06
 Purpose:   Fix JvMenus because ShortCutToText from Menus.pas as used in JvMenus
            does not allow translating keys like Ctrl, Shift etc. that need
            translating in some languages.
 Updated:   2014-08-18
-----------------------------------------------------------------------------}
unit JgbTranslateShortcut;

interface

{$I jvcl.inc} // We need the define to know whether JvGnuGetText translation is on.

{$IFDEF USE_DXGETTEXT}
uses SysUtils, Windows, Classes {TShortCut}, Consts,
  JvGnuGettext;

function ShortCutToText(ShortCut: TShortCut): string;

procedure RetranslateMenuKeyCaps;
{$ENDIF}

implementation


{$IFDEF USE_DXGETTEXT}

// Note: the original version of the code below is taken directly from
// Delphi 6 Menus.pas and as such is copyrighted, thus we can't publish this
// code anywhere!

type
  TMenuKeyCap = (mkcBkSp, mkcTab, mkcEsc, mkcEnter, mkcSpace, mkcPgUp,
    mkcPgDn, mkcEnd, mkcHome, mkcLeft, mkcUp, mkcRight, mkcDown, mkcIns,
    mkcDel, mkcShift, mkcCtrl, mkcAlt);

var
  MenuKeyCaps: array[TMenuKeyCap] of string = (
    SmkcBkSp, SmkcTab, SmkcEsc, SmkcEnter, SmkcSpace, SmkcPgUp,
    SmkcPgDn, SmkcEnd, SmkcHome, SmkcLeft, SmkcUp, SmkcRight,
    SmkcDown, SmkcIns, SmkcDel, SmkcShift, SmkcCtrl, SmkcAlt);

function GetSpecialName(ShortCut: TShortCut): string;
var
  ScanCode: Integer;
  KeyName: array[0..255] of Char;
begin
  Result := '';
  ScanCode := MapVirtualKey(WordRec(ShortCut).Lo, 0) shl 16;
  if ScanCode <> 0 then
  begin
    GetKeyNameText(ScanCode, KeyName, SizeOf(KeyName));
    GetSpecialName := KeyName;
  end;
end;

function ShortCutToText(ShortCut: TShortCut): string;
var
  Name: string;
begin
  case WordRec(ShortCut).Lo of
    $08, $09:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcBkSp) + WordRec(ShortCut).Lo - $08)];
    $0D: Name := MenuKeyCaps[mkcEnter];
    $1B: Name := MenuKeyCaps[mkcEsc];
    $20..$28:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcSpace) + WordRec(ShortCut).Lo - $20)];
    $2D..$2E:
      Name := MenuKeyCaps[TMenuKeyCap(Ord(mkcIns) + WordRec(ShortCut).Lo - $2D)];
    $30..$39: Name := Chr(WordRec(ShortCut).Lo - $30 + Ord('0'));
    $41..$5A: Name := Chr(WordRec(ShortCut).Lo - $41 + Ord('A'));
    $60..$69: Name := Chr(WordRec(ShortCut).Lo - $60 + Ord('0'));
    $70..$87: Name := 'F' + IntToStr(WordRec(ShortCut).Lo - $6F);
  else
    Name := GetSpecialName(ShortCut);
  end;
  if Name <> '' then
  begin
    Result := '';
    if ShortCut and scShift <> 0 then Result := Result + MenuKeyCaps[mkcShift];
    if ShortCut and scCtrl <> 0 then Result := Result + MenuKeyCaps[mkcCtrl];
    if ShortCut and scAlt <> 0 then Result := Result + MenuKeyCaps[mkcAlt];
    Result := Result + Name;
  end
  else Result := '';
end;

procedure RetranslateMenuKeyCaps;
begin
  // Since the resource strings are getting retranslated we just assign those
  // again instead of calling translate on them here.
  MenuKeyCaps[mkcBkSp] := SmkcBkSp;
  MenuKeyCaps[mkcTab] := SmkcTab;
  MenuKeyCaps[mkcEsc] := SmkcEsc;
  MenuKeyCaps[mkcEnter] := SmkcEnter;
  MenuKeyCaps[mkcSpace] := SmkcSpace;
  MenuKeyCaps[mkcPgUp] := SmkcPgUp;
  MenuKeyCaps[mkcPgDn] := SmkcPgDn;
  MenuKeyCaps[mkcEnd] := SmkcEnd;
  MenuKeyCaps[mkcHome] := SmkcHome;
  MenuKeyCaps[mkcLeft] := SmkcLeft;
  MenuKeyCaps[mkcUp] := SmkcUp;
  MenuKeyCaps[mkcRight] := SmkcRight;
  MenuKeyCaps[mkcDown] := SmkcDown;
  MenuKeyCaps[mkcIns] := SmkcIns;
  MenuKeyCaps[mkcDel] := SmkcDel;
  MenuKeyCaps[mkcShift] := SmkcShift;
  MenuKeyCaps[mkcCtrl] := SmkcCtrl;
  MenuKeyCaps[mkcAlt] := SmkcAlt;
end;

{$ENDIF}

end.
