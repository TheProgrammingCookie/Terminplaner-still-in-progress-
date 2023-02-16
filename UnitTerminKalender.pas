unit UnitTerminKalender;

interface

/// //////////////////////////////--INFO--///////////////////////////////////
///
///
//
/// /////////////////////////////////////////////////////////////////////////
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.DateUtils,
  Vcl.StdCtrls, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, Vcl.CategoryButtons, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.Imaging.jpeg, inifiles, Vcl.Grids, {Vcl.DBGrids,} System.Actions,
  Vcl.ActnList, FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSAcc, System.Generics.Collections,
  System.ImageList, Vcl.ImgList, Vcl.DBGrids, Vcl.DBCtrls, Firedac.stan.ExprFuncs,
  Vcl.Menus,CommCtrl,LadebalkenChat;

type
  TFOGantt = class(TForm)
    BTNTagesansicht: TButton;
    BTNMonatsansicht: TButton;
    BTNJahresansicht: TButton;
    Scrollganttbox: TScrollBox;
    EDDatum: TMaskEdit;
    BTNEinstellungen: TButton;
    BTNBeenden: TButton;
    NeuScrollbar: TScrollBar;
    FDMemTable1: TFDMemTable;
    DBGrid1: TDBGrid;
    panelHintergrund: TPanel;
    panelOben: TPanel;
    panelUnten: TPanel;
    panelMitte: TPanel;
    DataSource1: TDataSource;
    MainMenu1: TMainMenu;
    Anleitung: TMenuItem;
    Kontakt: TMenuItem;
    PJahresschild: TPanel;
    BTNSpeichern: TButton;
    TBLQuery: TFDQuery;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDConnection1: TFDConnection;

    procedure FormActivate(Sender: TObject);
    procedure BTNTagesansichtClick(Sender: TObject);
    procedure Ansichtpaint(Sender: TObject);

    procedure BTNMonatsansichtClick(Sender: TObject);
    procedure BTNJahresansichtClick(Sender: TObject);
    procedure AuftragMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AuftragMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure BTNSpeichernClick(Sender: TObject);
    procedure BTNEinstellungenClick(Sender: TObject);
    procedure SCrollbarschriftgroeßeOnScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure ScrollbarStrichstaerkeOnScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure MonatstrichfarbenAuswahlSelect(Sender: TObject);
    procedure BTNSpeichernEinstellungenOnClick(Sender: TObject);
    procedure AuftragFüllfarbenAuswahlSelect(Sender: TObject);
    procedure BTNBeendenClick(Sender: TObject);
    procedure Auftraegeerstellen;
    procedure BTNParametisierungSchließen(Sender: TObject);
    procedure NeuScrollbarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    // Prozeduren für die 3 verschiedenen Ansichten\\
    procedure AnzeigeJahr;
    procedure AnzeigeMonat;
    procedure Anzeigetag;
    procedure Markieren;
    procedure PansichtMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);

    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const [Ref] Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);


  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FOGantt: TFOGantt;
  PAnsicht: tpaintbox;

  // Booleans für die verschiedenen Ansichten
  boolMonatsansicht, boolJahresansicht, BoolTagesansicht,Markieren: bool;

  IAuftrag: TLadebalkenChat1    ;
  LabelAuftrag: Tlabel;

  Downpoint: Tpoint;
  LSchriftgroeßeBeispiel: Tlabel;

  inipath , AusgewaehlterAuftrag , ImageNamenMerken: string;

  BTNSchließen: TButton;
  LBeispielBuchstabe, LStrichfarbe: Tlabel;
  CMonatsstrichFarbe, CAuftragFüllFarbeAuswahl: TColorbox;
  Monatstrichfarbenauswahl, AuftragFarbfüllung: TColor;
  ScrollbarStrichstaerke, SCrollbarschriftgroeße: TScrollBar;
  ini: TIniFile;
  PAnsichtauswahlanzeige, PParametisierung: TPanel;
  BTNScrollbarPositionPlus, BTNScrollbarPositionMinus: TButton;
  AnsichtFaktor, IauftragFüllmenge: Integer;
  EinstellungenFenster: boolean;
  PAnsichtauswahlanzeigeimage: TImage;
  Lstrichstaerke2: Tlabel;

  // gibt das Aktuelle Jahr & Ansicht aus
  PJahresschild: TPanel;
  // booleans für die Koordination des Mausklicks des Auftrages
  bauftragverschieben, bauftragleftgroeßerkleiner, bauftragwidthgroeßerkleiner: boolean;
  strichstaerke , schriftgroeße, vertscrollpos , LeftinTage , AnzahlDatensaetze: integer;
  Monatstrichfarbe , auftragfarbe , auftragfarbe1 : string;
  Auftragmarkiert: boolean;
  MarkAuftrName : string;
  Auftraghoehe :  integer;

implementation




{$R *.dfm}




/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
procedure TFOGantt.SCrollbarschriftgroeßeOnScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  with LBeispielBuchstabe do
  begin
    LBeispielBuchstabe.Caption := inttostr(ScrollPos);
  end;
end;
/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
procedure TFOGantt.Anzeigetag;
var
// i für die Tage, i1 & i2 für die Stunden
// i3 & i4 für die Minuten
 i, i1, i2{,i3 , i4},stunde: integer;
tagende :string;
begin
   //Hier wird der Trennungsstrich gezeichnet
 with PAnsicht.canvas do
  begin
    pen.width := strichstaerke;
    moveto(0, BTNTagesansicht.Height + (btntagesansicht.Height  ));
    lineto(PAnsicht.width, BTNTagesansicht.Height + (btntagesansicht.Height )) ;

  end;
  // Die For Schleife wird benötigt um alle Tage und Stunden zu zeichnen
  for i := 0 to 366 do
   begin
    // _____________________________________________________________________________
      PAnsicht.canvas.pen.color := clred;
      // Anzeige Tage in der Tagesansicht
      PAnsicht.Parent := Scrollganttbox;
      PAnsicht.Font.Size := schriftgroeße;
      PAnsicht.canvas.TextOut((trunc(PAnsicht.width * i) div 366 +
        (PAnsicht.width div 366 div 4)), 0, FormatDateTime('dd' + '.' + 'mm',
      strtodatetime(EDDatum.text) + i));
      PAnsicht.canvas.pen.width := 3;
      PAnsicht.canvas.moveto(trunc((PAnsicht.clientwidth * i) div 366),
      btntagesansicht.height);
      PAnsicht.canvas.lineto(trunc((PAnsicht.clientwidth * i) div 366),
       PAnsicht.height);
      PAnsicht.canvas.pen.width := 1;
      PAnsicht.canvas.Font.Size := schriftgroeße;
      PAnsicht.canvas.TextOut((trunc(PAnsicht.width * i) div 366 +
       (PAnsicht.width div 366 div 3)), 0, FormatDateTime('mmmm',
      strtodatetime(EDDatum.text) + i));
      PAnsicht.canvas.Font.Size := schriftgroeße;
      PAnsicht.canvas.TextOut((trunc(PAnsicht.width * i) div 366 +
       (PAnsicht.width div 366 div 6)), 0, FormatDateTime('ddd',
      strtodatetime(EDDatum.text) + i));
      PAnsicht.canvas.pen.color := clblack;
        // Einzeichnung der Stunden
      for i1 := 0 to 23 do
       begin
              {PAnsicht.canvas.pen.width := 1;
              PAnsicht.canvas.pen.color := clblue;
               for i3 := 0 to 4 do
               begin
                PAnsicht.canvas.moveto(trunc(PAnsicht.width * i4) div 366 +
                (trunc((PAnsicht.width) * i3 div 366 div 24)) div 4 ,
                btntagesansicht.height);
                PAnsicht.canvas.lineto(trunc(PAnsicht.width * i4) div 366 +
                (trunc((PAnsicht.width) * i3 div 366 div 24))div 4, PAnsicht.height);
               end;  }
             i2 := i1 +1;
          // TAgende wird für die 24igste Stunde benoetigt das anstatt 0
          // ein ' ' drin steht
            TagEnde := inttostr(i1);
         PAnsicht.canvas.pen.width := 2;
         PAnsicht.canvas.pen.color := clblack;
         PAnsicht.canvas.Font.Size := schriftgroeße;
         // Berechnet die Stunde
         Stunde := trunc(((PAnsicht.width * 1) div 366 div 24) -
          ((PAnsicht.width * 1) div 366 div 24) div 4);
         PAnsicht.canvas.TextOut(trunc(PAnsicht.width * i) div 366 +
          (trunc((PAnsicht.width) * i2 div 366 div 24 - Stunde)),
         BTNTagesansicht.Height + (btntagesansicht.Height ) - (schriftgroeße  * 2), TagEnde);
        // Zeichnet Die Stunden
         PAnsicht.canvas.moveto(trunc(PAnsicht.width * i) div 366 +
          (trunc((PAnsicht.width) * i2 div 366 div 24)),
         btntagesansicht.height);
         PAnsicht.canvas.lineto(trunc(PAnsicht.width * i) div 366 +
          (trunc((PAnsicht.width) * i2 div 366 div 24)), PAnsicht.height);
       end;
   end;
end;
/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
procedure TFOGantt.AnzeigeMonat;
var
i : integer;
begin

  // Hier wird die Trenngrenze gezeichnet
  with PAnsicht.canvas do
  begin
    pen.width := strichstaerke;
    moveto(0, BTNTagesansicht.Height + (btntagesansicht.Height  ));
    lineto(PAnsicht.width, BTNTagesansicht.Height + (btntagesansicht.Height )) ;

  end;

  // Die For Schleife wird benötigt um alle Tage ein zu zeichnen
  for i := 0 to 366 do
  begin

   // hier werden die Tage gezeichnet
   PAnsicht.canvas.pen.width := strichstaerke;
   PAnsicht.canvas.pen.color := clblack;
   PAnsicht.canvas.moveto(trunc((PAnsicht.width * i) div 366),
   btntagesansicht.height);
   PAnsicht.canvas.lineto(trunc((PAnsicht.width * i) div 366),
   PAnsicht.height);

   // hier werden alle Monatsgrenzen gezeichnet sobald der erste jeden Monats erscheint
    if strtoint(FormatDateTime('dd', strtodatetime(EDDatum.text) + i)) = 1 then
    begin

      PAnsicht.canvas.pen.color := stringtocolor(Monatstrichfarbe);
      PAnsicht.canvas.pen.width := 3;
      PAnsicht.canvas.moveto(trunc((PAnsicht.clientwidth * i) div 366),
      btntagesansicht.height);
      PAnsicht.canvas.lineto(trunc((PAnsicht.clientwidth * i) div 366),
      PAnsicht.height);
      PAnsicht.canvas.pen.color := clblack;
      PAnsicht.canvas.pen.width := 1;
      PAnsicht.canvas.Font.Size := schriftgroeße;
      // hier Werden die Namen der Monate eingezeichnet
      PAnsicht.canvas.TextOut(trunc((PAnsicht.width * i) div 366 +
        (PAnsicht.width div 12 div 3)), 0, FormatDateTime('mmmm',
      strtodatetime(EDDatum.text) + i));

    end;

      PAnsicht.Parent := Scrollganttbox;
      PAnsicht.canvas.Font.Size := schriftgroeße;
      // hier wird der wievielte und um welchen Tag es sich handelt angezeigt(Eingezeichnet)
      PAnsicht.canvas.TextOut((trunc(PAnsicht.width * i) div 366 +
       (PAnsicht.width div 366 div 20)),BTNTagesansicht.Height + (btntagesansicht.Height ) - (schriftgroeße  * 2),
      FormatDateTime('dd'+' '+'ddd', strtodatetime(EDDatum.text) + i));
  end;

end;
/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
procedure TFOGantt.AnzeigeJahr;
var
i : integer;
begin


  // Hier wird die Trennungslinie gezeichnet die unter den Monatsnamen steht
  with PAnsicht.canvas do
  begin
    pen.width := strichstaerke;
    moveto(0, BTNTagesansicht.Height + (btntagesansicht.Height ));
    lineto(PAnsicht.width, BTNTagesansicht.Height + (btntagesansicht.Height )) ;

  end;
  // wenn die Paintbox kleiner als die scrollbox sein sollte durch z.b einen einzelnen auftrag wird
  // dessen Hoehe an die Scrollbox angepasst
   if PAnsicht.height < Scrollganttbox.height then
  begin

    PAnsicht.height := Scrollganttbox.height - (Scrollganttbox.top div 2);;
    Scrollganttbox.vertscrollbar.visible := false;

  end;

  // Die For Schleife wird benötigt um alle Monatsgrenzen anzeigen zu lassen
  // 366 und nicht 12 da manche Monate nicht immer gleich groß von den Tagen sind
 for i := 0 to 366 do
  begin

    // _____________________________________________________________________________
    // Sobald ein Tag mit 01 oder der erste jeden monats aufkommt, wird ein strich gezeichnet
    // somit hat man die Visuelle Darstellung eines Monatsabschnitts
   if strtoint(FormatDateTime('dd', strtodatetime(EDDatum.text) + i)) = 1 then
    begin
     // hier wird die gewünschte Farbe der Monatstrennung zugewiesen
      PAnsicht.canvas.pen.color := stringtocolor(Monatstrichfarbe);

      // Hier werden die Monatsgrenzen gezeichnet
        PAnsicht.canvas.pen.width := 3;
        PAnsicht.canvas.moveto(trunc((i * PAnsicht.width) div 366) -
          ((1 * PAnsicht.width) div 366 div 2),
                              BTNTagesansicht.Height * 2 - (btntagesansicht.Height div 2 )
                              );

        PAnsicht.canvas.lineto(trunc((i * PAnsicht.width) div 366) -
          ((1 * PAnsicht.width) div 366 div 2), PAnsicht.height);
        PAnsicht.canvas.pen.color := clblack;
        PAnsicht.canvas.pen.width := 1;

        // Hier wird der Monatsname gezeichnet
        PAnsicht.canvas.Font.Size := schriftgroeße;
        PAnsicht.canvas.TextOut(trunc((PAnsicht.width * i) div 366 +
          (PAnsicht.width div 12 div 4       )),btntagesansicht.height ,
          FormatDateTime('mmmm', strtodatetime(EDDatum.text) + i));
    end;

  end;

end;

/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////

procedure TFOGantt.FormActivate(Sender: TObject);
begin

  FOGantt.Align := alClient;
 //Die Ini Datei CSetting wird geöffnet und daraus die Werte für bestimmte Variablen zugewiesen
  inipath := ExtractFilePath(ParamStr(0)) + 'CSetting.ini';
  ini := TIniFile.Create(inipath);
  strichstaerke := (ini.readinteger('Parametisierung', 'Strichstaerke', 0));
  schriftgroeße := ini.readinteger('Parametisierung', 'Buchstaben Groeße', 0);
  auftragfarbe1 :=  ini.readstring('Parametisierung', 'AuftragFarbfüllung', 'clblue');
  Monatstrichfarbe := ini.readstring('Parametisierung', 'Monatstrichfarbenauswahl', 'clred');
  EDDatum.text :=(ini.ReadString('Daten', 'EingabeDatumAnfang', ( FormatDateTime('dd.mm.yyyy', Now) ) )) ;
  ini.free;

  //Das Caption des Panels (Jahresschild) wird befüllt und nach forne gebracht
  with PJahresschild do
  begin

    font.Size := schriftgroeße;
    Caption := 'Jahresansicht | '+ FormatDateTime('yyyy',strtodatetime(EDDatum.Text));
    BringToFront;
  end;



  Auftraghoehe :=   38;// trunc(screen.height div 35) * 2;

 // Alle Daten aus der Tabelle Cepio wo die Connid 4 beträgt werden geladen und dessen Struktur in die Memtable übergegeben
  TBLQuery.sql.text := 'SELECT * FROM cepio WHERE CONNID = 4 '; //vorrübergehend
  TBLQuery.Open();
  FDMemTable1.CopyDataSet(TBLQuery, [coStructure, coAppend]);
  AnzahlDatensaetze := FDMemTable1.RecordCount;
  FDMemTable1.Open;


   BTNJahresansicht.click;



end;



/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
{procedure TFOGantt.Auftragverlassen(Sender: TObject);
begin

  bauftragverschieben := false;
  bauftragleftgroeßerkleiner := false;
  bauftragwidthgroeßerkleiner := false;

  screen.Cursor := crDefault;

end;}
/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////


/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////

procedure TFOGantt.AuftragMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //MarkAuftrName
  AusgewaehlterAuftrag := (Sender as TLadebalkenChat1    ).name;
  (sender as TLadebalkenChat1    ).BringToFront;
  Auftragmarkiert := true;


 with NeuScrollbar do
  begin

    Parent := FOGantt;

    left := Scrollganttbox.left;
    width := Scrollganttbox.width;
    height := Scrollganttbox.height div 25;
    top := panelMitte.Top + panelMitte.Height - NeuScrollbar.Height;

  end;
  // bauftragverschieben,bauftragleftgroeßerkleiner , bauftragwidthgroeßerkleiner
  if (X > (Sender as TLadebalkenChat1    ).width - (BTNTagesansicht.width div 30))then
  begin


    bauftragwidthgroeßerkleiner := true;
    bauftragleftgroeßerkleiner := false;
    bauftragverschieben := false;
  end;

 // showmessage( (sender as TLadebalkenChat1).name);


  if (X > (BTNTagesansicht.width div 30)) and
    (X < (Sender as TLadebalkenChat1    ).width - (BTNTagesansicht.width div 30)) then
  begin
    bauftragverschieben := true;
    bauftragleftgroeßerkleiner := false;
    bauftragwidthgroeßerkleiner := false;
  end;

  if (X < (BTNTagesansicht.width div 30)) then
  begin
    bauftragleftgroeßerkleiner := true;
    bauftragverschieben := false;
    bauftragwidthgroeßerkleiner := false;
  end;

  // Mausklickkoordinaten auf dem Auftragsimage werden gespeichert
   Downpoint.X := X;
   Downpoint.Y := Y;

end;

/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////

procedure TFOGantt.BTNTagesansichtClick(Sender: TObject);
begin
// Die Boolischen Werte nach dem sich z.b das OnPaint event der Painbox richtet werden eingestellt
  BoolTagesansicht := true;
  boolJahresansicht := false;
  boolMonatsansicht := false;

// Der Faktor für die Tagesansicht wird bereitgestellt
  AnsichtFaktor := (Scrollganttbox.width * 366 ) ;
// Die Prozedur für die Erstellung der Aufträge wird gestartet
  Auftraegeerstellen;

end;




procedure TFOGantt.DBGrid1CellClick(Column: TColumn);
var
 VertScrollbarPositionberechnung : integer;
begin


   //Scrollganttbox.VertScrollBar.Position := Auftraghoehe * FDMemTable1.FieldByName('ID').AsInteger ;
  // BTNTagesansicht.Caption := IntToStr(FDMemTable1.FieldByName('ID').AsInteger);

   VertScrollbarPositionberechnung := Scrollganttbox.VertScrollBar.Range div  (FDMemTable1.RecordCount +1 );

  Scrollganttbox.VertScrollBar.Position := (VertScrollbarPositionberechnung  * (FDMemTable1.FieldByName('ID').AsInteger)) -
   (BTNTagesansicht.Height div 2);

  Auftragmarkiert := true;
   AusgewaehlterAuftrag := 'Auftrag' + (FDMemTable1.FieldByName('ID').Asstring);

   // Die Horizontale Position der Scrollbars werden an den Auftragspositionen angepasst
  if (boolMonatsansicht = true) or (BoolTagesansicht = true) then
  begin

    Scrollganttbox.HorzScrollBar.Position :=   ((Scrollganttbox.HorzScrollBar.Range * (DaysBetween(strtodatetime(EDDatum.text),
        FDMemTable1.FieldByName('ABDATUM').asdatetime)) ) div 366  ) ;

    NeuScrollbar.Position := Scrollganttbox.HorzScrollBar.Position;
                                                                                   //  ((FindComponent(AusgewaehlterAuftrag)) as TLadebalkenChat1    ).Left
    end;




   PAnsicht.OnPaint := Ansichtpaint;
   Scrollganttbox.refresh;

   dbgrid1.SelectedRows.CurrentRowSelected := True;

  // dbgrid1.IsRightToLeft := true;

  DBGrid1.setfocus;


 //  BTNSpeichern.Caption :=


end;



procedure TFOGantt.DBGrid1DrawColumnCell(Sender: TObject;
  const [Ref] Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin



      {with dbgrid1 do
      begin

       Canvas.Brush.Color := clRed;
       canvas.pen.Width := 3;
       canvas.Pen.Color := clGreen;

       Canvas.Brush.Color := clWhite;
      DefaultDrawColumnCell(Rect, DataCol, Column, State);

      end;}




end;

/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
procedure TFOGantt.BTNMonatsansichtClick(Sender: TObject);

begin
// Die Boolischen Werte nach dem sich z.b das OnPaint event der Painbox richtet werden eingestellt
  BoolTagesansicht := false;
  boolJahresansicht := false;
  boolMonatsansicht := true;
// Der Faktor für die Monatsansicht wird bereitgestellt
  AnsichtFaktor := trunc((Scrollganttbox.clientwidth * 366) div 31);
// Die Prozedur für die Erstellung der Aufträge wird gestartet
  Auftraegeerstellen;
end;

/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
procedure TFOGantt.BTNParametisierungSchließen(Sender: TObject);
begin
 // Einstellungenfenster wird auf false gesetzt damit beim wieder öffnen kein Fehler entsteht
  EinstellungenFenster := false;
// Die gesamte Parametisierung wird frei gegeben
  PParametisierung.free;

end;
/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////

procedure TFOGantt.BTNSpeichernEinstellungenOnClick(Sender: TObject);
begin

  inipath := ExtractFilePath(ParamStr(0)) + 'CSetting.ini';

  ini := TIniFile.Create(inipath);
  with ini do
  begin

    // Hier werden die in den Variablen gespeicherten werte in die InI Datei übergeben
    ini.Writeinteger('Parametisierung', 'Monatstrichfarbenauswahl',
      Monatstrichfarbenauswahl);
    ini.Writeinteger('Parametisierung', 'AuftragFarbfüllung',
      AuftragFarbfüllung);
    ini.Writeinteger('Parametisierung', 'Buchstaben Groeße',
      SCrollbarschriftgroeße.Position);
    ini.Writeinteger('Parametisierung', 'Strichstaerke',
      ScrollbarStrichstaerke.Position);
    ini.Writeinteger('Parametisierung', 'LBeispielbuchstabenWidth',
      LBeispielBuchstabe.width);

  end;

  ini.free;
  strichstaerke:= ScrollbarStrichstaerke.Position;
  schriftgroeße:= SCrollbarschriftgroeße.Position;
  auftragfarbe1 := inttostr( AuftragFarbfüllung);
  Monatstrichfarbe := inttostr(Monatstrichfarbenauswahl);
  // nach dem Speichern werden die Buttons erneut gedrückt um alles mit den neuen Werten zu aktualisieren
  if BoolTagesansicht = true then
  begin
    BTNTagesansicht.Click;
  end;
  if boolMonatsansicht = true then
  begin
    BTNMonatsansicht.Click;
  end;
  if boolJahresansicht = true then
  begin
    BTNJahresansicht.Click;
  end;

end;


/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////

procedure TFOGantt.BTNSpeichernClick(Sender: TObject);
var
  // i wird für Lokale schleifen verwendet
  i, X: Integer;
  SpeichernArt : String;

begin

// hier wird aus der INI Datei überprüft wohin die Daten gespeichert werden sollen
   inipath := ExtractFilePath(ParamStr(0)) + 'CSetting.ini';
   ini := TIniFile.Create(inipath);
   SpeichernArt := (ini.readstring('Speichern', 'WoSpeichern', 'ExterneDatei'));
   ini.free;
   if SpeichernArt = 'DBTabelle' then
   begin
    TBLQuery.Open();
     with FDMemTable1 do
     begin
        // Hier wird durch eine While Schleife überprüft ob die Spalte 'Stati' die 1 besitzt, wenn ja werden die Daten gespeichert
       while (fdmemtable1.Locate('Stati' ,  '1',[]   )=true)  do
       begin

       //howmessage('Daten schreiben');

         TBLQuery.Locate('ID', FDMemTable1.FieldByName('ID').Value);
             TBLQuery.Edit;
         TBLQuery.FieldByName('AbDatum').Value := FDMemTable1.FieldByName('Abdatum').Value;
         TBLQuery.FieldByName('bisdatum').Value := FDMemTable1.FieldByName('bisdatum').Value;
         TBLQuery.FieldByName('bisuhr').Value := FDMemTable1.FieldByName('bisuhr').Value;
         TBLQuery.FieldByName('abuhr').Value := FDMemTable1.FieldByName('abuhr').Value;
         // Nach Locate muss die memtable wieder in den Edit modus versetzt werden
         Edit;
         FieldByName('stati').asstring:='';
          post;
        TBLQuery.Post;
       end;
       Exit;
     end;
   end else
       begin
        //  Wenn die Speicherung nicht in der Tabelle stattfinden soll, dann in der Externen Datei
         if SpeichernArt = 'ExterneDatei' then
         begin
         // Die Möglichkeit in eine Externe zu Speichern ist noch nich gegeben
          ShowMessage('Speichere in exterene Datei');

         end;

       end;




end;

/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
procedure TFOGantt.AuftragFüllfarbenAuswahlSelect(Sender: TObject);
begin
 // Die Ausgewählte Farbe wird der Variable übergeben
  AuftragFarbfüllung := CAuftragFüllFarbeAuswahl.Selected;

end;
/// //////////////////////////////////////////Prozedur///////////////////////////////////////////////

procedure TFOGantt.Markieren;
begin


 with PAnsicht.Canvas Do
 begin

  if Auftragmarkiert = true then
  begin
 // Auftrag wird Markiert
     pen.Width := 3;
     pen.Color := clBlue;// man kann in der Parametisierung noch eine Farbauswahl Hinzufügen
     Rectangle(Scrollganttbox.horzscrollbar.position + ((FindComponent(AusgewaehlterAuftrag)) as TLadebalkenChat1    ).Left -1 , Scrollganttbox.VertScrollBar.Position + ((FindComponent(AusgewaehlterAuftrag)) as TLadebalkenChat1    ).Top -1 ,Scrollganttbox.horzscrollbar.position +((FindComponent(AusgewaehlterAuftrag)) as TLadebalkenChat1    ).Left + ((FindComponent(AusgewaehlterAuftrag)) as TLadebalkenChat1    ).Width +1, Scrollganttbox.VertScrollBar.Position + ((FindComponent(AusgewaehlterAuftrag)) as TLadebalkenChat1    ).Top + ((FindComponent(AusgewaehlterAuftrag)) as TLadebalkenChat1    ).Height  +1
     );
  end;


 end;


end;

procedure TFOGantt.MonatstrichfarbenAuswahlSelect(Sender: TObject);
begin
// Die Monatsrennfarbe wird er Variable übergeben
  Monatstrichfarbenauswahl := CMonatsstrichFarbe.Selected;

end;

procedure TFOGantt.PansichtMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
// wenn der Mauszeiger nicht im Standart Zustand ist, wird er wieder in den Standart zurück gebracht
// zudem werden auch die Boolischen Werte für die Mausposition im Auftrag wieder zurück gesetzt
 if (screen.Cursor <> crDefault) then
 Begin
     bauftragverschieben := false;
     bauftragleftgroeßerkleiner := false;
     bauftragwidthgroeßerkleiner := false;
     Screen.Cursor := crDefault;
 End;

end;

/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////


procedure TFOGantt.BTNBeendenClick(Sender: TObject);
begin
// Die Form und somit das Programm beendet.
  FOGantt.Close;

end;


/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////

procedure TFOGantt.BTNEinstellungenClick(Sender: TObject);
var
  LSchriftgroeße, LStrichstaerke, LMonatstrichfarbe, LAuftragFüllung: Tlabel;
  colorboxmonat ,auftragfarbe , colorboxtag: TColor;
  scrollbarstrichstaerkeposition, Scrollbarbuchstabengroeßeposition: Integer;
  BTNSpeichernEinstellungen, BTNSchließen, BTNHintergrundAuswahl , BTNFarbauswahl: TButton;

begin
// wenn einstellungenfenster geschlossen ist was mit dem boolische wert überprüft wird,
// wird das Fenster mit all seinen Objekten neu erzeugt.
  if EinstellungenFenster = false then
  begin
    // Der boolische Wert des Einstellungsfensters wird auf true gesetzt damit das Fenster nicht neu erstellt wird
    EinstellungenFenster := true;
    // hier werden alle Daten erneut aus der INI Datei für die Objekte innerhalb des fensters geladen
    inipath := ExtractFilePath(ParamStr(0)) + 'CSetting.ini';
    ini := TIniFile.Create(inipath);
    colorboxmonat := stringtocolor(ini.readstring('Parametisierung',
      'Monatstrichfarbenauswahl', 'clred'));
    scrollbarstrichstaerkeposition := ini.readinteger('Parametisierung',
      'Strichstaerke', 0);
    Scrollbarbuchstabengroeßeposition := ini.readinteger('Parametisierung',
      'Buchstaben Groeße', 0);
    auftragfarbe := stringtocolor(ini.readstring('Parametisierung',
      'AuftragFarbfüllung', 'clblue'));
    ini.free;

    // Das Panel des Fensters wird erzeugt
    PParametisierung := TPanel.Create(self);
    with PParametisierung do
    begin

     // Positionierung des Fensters
      Parent := FOGantt;
      left := BTNEinstellungen.left;
      width := Scrollganttbox.left + Scrollganttbox.width - BTNEinstellungen.left;
      top := BTNEinstellungen.Top + BTNEinstellungen.Height;
      height := Scrollganttbox.height div 2;
      canvas.Font.Size := 30;
      LSchriftgroeße := Tlabel.Create(self);
      bevelkind := bknone;
      Bevelinner := bvspace;
      BevelOuter := bvspace;
      color := clcream;
      pparametisierung.ParentBackground := false;

     // Das Label steht über der Auswahlscrollbar um die Schriftgröße zu bestimmen
      with LSchriftgroeße do
      begin



        Parent := PParametisierung;
        left := PParametisierung.width div 20;
        top := PParametisierung.height div 30;
        Caption := 'Schriftgroeße : ';
        visible := true;
        name := 'LSchriftgroeße';
      end;
    // Das Label für die Schriftgroeße als Beispiel wird Positioniert
      LBeispielBuchstabe := Tlabel.Create(self);
      with LBeispielBuchstabe do
      begin
        Parent := PParametisierung;
        top := LSchriftgroeße.top + LSchriftgroeße.height +
          (LSchriftgroeße.height div 4);
        left := PParametisierung.width div 2 + (PParametisierung.width div 5);
        Font.Size := 15;
        visible := true;
        name := 'LBeispielBuchstabe';
        Caption := inttostr(Scrollbarbuchstabengroeßeposition);

      end;
       // Die scrollbar für die Einstellung der gewuenschten Schriftgroeße wird Positioniert und
       // Die Position geladen auf dem Sie steht
      SCrollbarschriftgroeße := TScrollBar.Create(self);
      with SCrollbarschriftgroeße do
      begin

        Parent := PParametisierung;
        visible := true;
        left := PParametisierung.width div 20;
        Position := Scrollbarbuchstabengroeßeposition;
        width := PParametisierung.width div 2;
        Name := 'SCrollbarschriftgroeße';
        top := LSchriftgroeße.top + LSchriftgroeße.height +
          (LSchriftgroeße.height div 2);
        SCrollbarschriftgroeße.Max := 20;
        SCrollbarschriftgroeße.Min := 8;

        Onscroll := SCrollbarschriftgroeßeOnScroll;

      end;

      // Das Label steht ueber der Strichstaerkescrollbar fuer die Einstellungsmoeglichkeit der Strichstaerke
      LStrichstaerke := Tlabel.Create(self);
      with LStrichstaerke do
      begin
        Parent := PParametisierung;
        top := SCrollbarschriftgroeße.top + SCrollbarschriftgroeße.height +
          (SCrollbarschriftgroeße.height div 2);
        left := PParametisierung.width div 20;
        Caption := ' Strichstaerke : ';
        name := 'LStrichstaerke';
      end;
     // Die strichstaerkescrollbar wird hier Positioniert
     // Sie ist dafür da um die Strichstärke nach Wunsch zu bestimmen
      ScrollbarStrichstaerke := TScrollBar.Create(self);
      with ScrollbarStrichstaerke do
      begin

        Parent := PParametisierung;
        visible := true;
        width := PParametisierung.width div 2;
        left := PParametisierung.width div 20;
        top := LStrichstaerke.top + LStrichstaerke.height +
          (SCrollbarschriftgroeße.height div 2);

        ScrollbarStrichstaerke.Min := 1;
        ini := TIniFile.Create(inipath);
        Position := ini.readinteger('Parametisierung', 'Strichstaerke', 0);
        ini.free;

        ScrollbarStrichstaerke.Max := 10;

        Onscroll := ScrollbarStrichstaerkeOnScroll;

      end;
    //Hier wird das strichstaerkenlabel positioniert
    // Das Strichstaerkenlabel wird als Anzeige eingesetzt
    // damit man weis auf welcher Größe sich die Akutelle ausgewaehlte Größe befindet
      Lstrichstaerke2 := Tlabel.Create(self);
      with Lstrichstaerke2 do
      begin
        Parent := PParametisierung;
        left := PParametisierung.width div 2 + (PParametisierung.width div 5);
        Font.Size := LBeispielBuchstabe.Font.Size;
        top := LStrichstaerke.top + LStrichstaerke.height -
          trunc(LStrichstaerke.height div 4);
        Name := 'Lstrichstaerke2';
        Caption := inttostr(ScrollbarStrichstaerke.Position);

      end;

    // Hier Wird das Label fuer die Auswahl der gewünschten Monatsstrichfarbe Positioniert.
    // Dieses Label steht nur ueber der Auswahlmglichkeit
      LMonatstrichfarbe := Tlabel.Create(self);
      with LMonatstrichfarbe do
      begin

        Parent := PParametisierung;
        top := ScrollbarStrichstaerke.top + ScrollbarStrichstaerke.height +
          (ScrollbarStrichstaerke.height div 2);
        left := PParametisierung.width div 20;
        Caption := ' Monatstrichfarbe : ';
        Name := 'LMonatstrichfarbe';
      end;

    // Die Colorbox wird hier Positioniert fuer die Auswahl der Gewünschten Farbe der Monatsstrichtrennung
      CMonatsstrichFarbe := TColorbox.Create(self);
      with CMonatsstrichFarbe do
      begin

        Parent := PParametisierung;
        Selected := colorboxmonat;
        top := LMonatstrichfarbe.top;
        { LMonatstrichfarbe.top + LMonatstrichfarbe.height +
          (SCrollbarschriftgroeße.height div 2); }
        left := LMonatstrichfarbe.left + LMonatstrichfarbe.width +
          PParametisierung.width div 20; { PParametisierung.width div 20; }
        width := (PParametisierung.width - left) -
          ((PParametisierung.width div 20));
        name := 'CMonatsstrichFarbe';
        // Hier wird die momentante Farbe geladen die man davor oder im letzen benutzen Ausgewählt hat
        OnSelect := MonatstrichfarbenAuswahlSelect;
        // hier wird die ausgewählte Farbe der Variable zugewiesen
        Monatstrichfarbenauswahl := CMonatsstrichFarbe.Selected;


      end;
    // Das Label ist für die Anzeige da damit man weis was man mir der anderen Colorbox verändern kann
      LAuftragFüllung := Tlabel.Create(self);
      with LAuftragFüllung do
      begin

        Parent := PParametisierung;
        // uftragfüllung.WordWrap := true;
        top := trunc(CMonatsstrichFarbe.top + (CMonatsstrichFarbe.height) +
          (ScrollbarStrichstaerke.height div 2));
        left := PParametisierung.width div 20;
        Caption := 'Farbfüllung  ' + #13#10 + ' des Auftrags : ';
        visible := true;
        Name := 'LauftragsFüllung';
      end;
       // Die Colorbox ist für die Auswahl der gewuenschten
       // Farbe der Auftraege
      CAuftragFüllFarbeAuswahl := TColorbox.Create(self);
      with CAuftragFüllFarbeAuswahl do
      begin

        Parent := PParametisierung;
        Selected := auftragfarbe;
        top := LAuftragFüllung.top;
        left := CMonatsstrichFarbe.left;
        width := CMonatsstrichFarbe.width;
        OnSelect := AuftragFüllfarbenAuswahlSelect;
        AuftragFarbfüllung := CAuftragFüllFarbeAuswahl.Selected;

      end;
      // Positionierung und Erzeugung Des Speichernbuttons
      BTNSpeichernEinstellungen := TButton.Create(self);
      with BTNSpeichernEinstellungen do
      begin

        Parent := PParametisierung;
        width := PParametisierung.width div 2;
        left := 0;
        height := BTNMonatsansicht.height;
        Name := 'BTNSpeichernEinstellungen';

        top := PParametisierung.height - height;
        Caption := 'Speichern';

        OnClick := BTNSpeichernEinstellungenOnClick;
      end;
     // Positionierung und Erzeugung des Schließen Buttons
      BTNSchließen := TButton.Create(self);
      with BTNSchließen do
      begin

        Parent := PParametisierung;
        left := PParametisierung.width div 2;
        height := BTNMonatsansicht.height;
        top := BTNSpeichernEinstellungen.top;
        width := PParametisierung.width div 2;
        Caption := 'Schließen';
        OnClick := BTNParametisierungSchließen;

      end;

    end;
  end
  else
  begin
    // Setzt die Richtigen Buttons in die Markierung dessen Ansicht man gerade Aktuell offen hat
    if BoolTagesansicht = true then
    begin
      BTNTagesansicht.SetFocus;

    end;

    if boolMonatsansicht = true then
    begin
      BTNMonatsansicht.SetFocus;

    end;

    if boolJahresansicht = true then
    begin
      BTNJahresansicht.SetFocus;

    end;
   // Parametiserungsfenster wird frei gegeben und neu erzeugt sobald man doppelt auf das Einstellungsfenster drueckt
    if EinstellungenFenster = true then
    begin

      EinstellungenFenster := false;
      PParametisierung.free;

    end;
  end;

end;
/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////

procedure TFOGantt.ScrollbarStrichstaerkeOnScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
 // Strichstaerkelabel anzeige der momentan Größe der Eingestellten Strichstaerkengroeße
  with PParametisierung do
  begin
    Lstrichstaerke2.Caption := inttostr(ScrollbarStrichstaerke.Position);
  end;

end;

/// ////////////////////////////////////////// Prozedur /////////////////////////////////////////////

procedure TFOGantt.Auftraegeerstellen;
var
 iABUHRStunde, iBISUHRStunde, i   , {Faktor1Minute ,} auftragfarbe, Differenz,    iABUhrMinute , iBisUhrMinute  : Integer;
 // sDatumEdit ,sBeginDatum , sEndDatum : double;
   Zeichnen : string;
begin
// Die Aufraghoehe wird festgelegt

// Die vertikale Scrollbar Position wird übergeben damit man in einer andere Ansicht auf dem gleichen Punkt steht
  vertscrollpos := Scrollganttbox.VertScrollBar.Position ;

  // ______________________________________________________________________________
  // Beide Scrollbars dessen Sichtbarkeit wird auf true gesetzt
  Scrollganttbox.HorzScrollBar.visible := true;
  Scrollganttbox.vertscrollbar.visible := true;
 // Jahresschild wird mit der Aktuellen Anzeige befüllt
    with PJahresschild do
  begin

    font.Size := schriftgroeße;


    if BoolTagesansicht = true then
    begin
      BTNTagesansicht.SetFocus;
      Caption := 'Tagesansicht | ' + FormatDateTime('yyyy', strtodatetime(EDDatum.text));
    end;

    if boolMonatsansicht = true then
    begin
      BTNMonatsansicht.SetFocus;
      Caption := 'Monatsansicht | ' + FormatDateTime('yyyy', strtodatetime(EDDatum.text));
    end;

    if boolJahresansicht = true then
    begin
      BTNJahresansicht.SetFocus;
      Caption := 'Jahresansicht | '+FormatDateTime('yyyy', strtodatetime(EDDatum.text));

    end;

  end;
 // Memtable wird geöffnet in den Lesemodus versetzt
  FDMemTable1.Open();
  FDMemTable1.First;
 // In der While Schleife wird geprüft ob die Auftraege schon existieren
 // Wenn ja werden sie Frei gegeben
  While not FDMemTable1.Eof do
  begin
    ((FindComponent('Auftrag' + (FDMemTable1.FieldByName('ID').asstring)) as TLadebalkenChat1    ).free);
    ((FindComponent('Labelauftrag' + (FDMemTable1.FieldByName('ID').asstring)) as Tlabel).free);
    FDMemTable1.Next
  end;

  with pansicht do
  begin
   // Falls eine Paintbox(PAnsicht) schon existiert wird sie frei gegeben
   free;
   // Paintbox(PAnsicht) wird erzeugt
   PAnsicht := tpaintbox.Create(self);
   enabled := true;
   // Positionierung der Paintbox(Pansicht)
   Parent := Scrollganttbox;
   width := AnsichtFaktor;
  end;



  // Painbox wird pro Neu erzeugten Auftrag erweitert damit man auch soweit herunterscrollen kann
  pansicht.Height :=(screen.height div 30 * 2)  + ((Auftraghoehe *2 )*AnzahlDatensaetze)  ;
  // Position der Memtable wird auf den ersten Platz gesetzt
  FDMemTable1.First;
  // while Schleife in der die Auftraege erstellt werden
  While not FDMemTable1.Eof do
  begin
    iABUHRStunde :=    (trunc((Ansichtfaktor) * (strtoint(formatdatetime('hh' , FDMemTable1.FieldByName('ABUHR').AsDateTime ) ))  div 366 div 24));
    iBISUHRStunde :=  (trunc((Ansichtfaktor) * (strtoint(formatdatetime('hh' , FDMemTable1.FieldByName('BISUHR').AsDateTime ) ))  div 366 div 24));
    iABUhrMinute :=   (((trunc((Ansichtfaktor) * 1 div 366 div 24) div 60 ) * (strtoint(formatdatetime('nn' , FDMemTable1.FieldByName('Abuhr').AsDateTime ) )))) ;
    iBisUhrMinute :=  (((trunc((Ansichtfaktor) * 1 div 366 div 24) div 60 ) * (strtoint(formatdatetime('nn' , FDMemTable1.FieldByName('Bisuhr').AsDateTime ) )))) ;

   // sBeginDatum :=  (FDMemTable1.FieldByName('ABDATUM').AsDateTime) ;
    //sEndDatum := ( FDMemTable1.FieldByName('BISDATUM').asdatetime);

  //  Faktor1Minute := (trunc((PAnsicht.width) * 1 div 366 div 24) div 60 );
   // sDatumEdit := StrTodate(EDDatum.text);
   // Auftrag wird erstellt als Ladebalken
    IAuftrag := TLadebalkenChat1.Create(self);

     //iauftrag.Color := clSkyBlue;
    // Zuweisung welcher Struktur
    IAuftrag.Parent := Scrollganttbox;
    // Bestimmung des Left wertes in einer Berechnung für den Tagesabstand
    // _____________________________________________________________________________________________________________________________________

    // Auftrag innerhalb des Jahres      1
    {if ( StrToInt(sBeginDatum) >= StrToInt(sDatumEdit)) and (StrToInt(sBeginDatum) < StrToInt(sDatumEdit) + 366) and
      ( StrToInt(sEndDatum) >= StrToInt(sDatumEdit)) and (StrToInt(sEndDatum) <= StrToInt(sDatumEdit) + 366) then
     begin}

     // Wenn sich der Auftrag innerhalb des gewünschten Zeitraums von einem Jahr befindet, wird er innerhalbt erzeugt
     //
    if (FDMemTable1.FieldByName('ABDATUM').asdatetime >=    strtodatetime(EDDatum.text)) and
       (FDMemTable1.FieldByName('ABDATUM').asdatetime <  strtodatetime(EDDatum.text) + 366) and
       (FDMemTable1.FieldByName('BISDATUM').asdatetime  >= strtodatetime(EDDatum.text)) and
       (FDMemTable1.FieldByName('BISDATUM').asdatetime <= strtodatetime(EDDatum.text) + 366) then
       begin

        IAuftrag.left := trunc((PAnsicht.width) * (DaysBetween(strtodatetime(EDDatum.text),
        FDMemTable1.FieldByName('ABDATUM').asdatetime)) div 366) + iABUHRStunde  +  iABUhrMinute;
        if BoolTagesansicht = True then
        begin
          IAuftrag.left := trunc((  PAnsicht.width) * (DaysBetween(strtodatetime(EDDatum.text),
         FDMemTable1.FieldByName('ABDATUM').asdatetime)) div 366) + iABUHRStunde  +  iABUhrMinute;
        end;

        IAuftrag.width :=
        trunc((((PAnsicht.width) * (DaysBetween(( FDMemTable1.FieldByName('ABDATUM').asdatetime ),
        FDMemTable1.FieldByName('BISDATUM').asdatetime)) div 366) -
        ( iABUhrstunde))  + iBISUHRStunde ) - iABUhrMinute + ibisuhrMinute ;

       end
    else
      begin

         // Auftrag wenn das Auftragsende in das Jahr faellt
        if (FDMemTable1.FieldByName('ABDATUM').asdatetime <=
          strtodate(EDDatum.text)) and



          (FDMemTable1.FieldByName('BISDATUM').asdatetime <
          (strtodate(EDDatum.text) + 366)) then
         begin



          IAuftrag.left := 0;
          IAuftrag.width :=
          trunc(((PAnsicht.width) * (DaysBetween((        FDMemTable1.FieldByName('ABDATUM').asdatetime         ),
          FDMemTable1.FieldByName('BISDATUM').asdatetime)) div 366)
            + iBISUHRStunde ) + ibisuhrMinute ;


         end
        else
         begin

             // 3 Auftrag Anfang groeßer edd und ende groeßer als das Jahr
           if (FDMemTable1.FieldByName('ABDATUM').asdatetime >=
                strtodate(EDDatum.text)) and
               (FDMemTable1.FieldByName('ABDATUM').asdatetime <
                strtodate(EDDatum.text) + 366) and
               (FDMemTable1.FieldByName('BISDATUM').asdatetime >
                strtodate(EDDatum.text) + 366) then
               begin

                IAuftrag.left := trunc((PAnsicht.width)) *
                (DaysBetween(strtodatetime(EDDatum.text),
                FDMemTable1.FieldByName('ABDATUM').asdatetime)) div 366 +  iABUHRStunde ;

                  if IAuftrag.left = PAnsicht.width div 2 then
                    begin
                     IAuftrag.width := PAnsicht.width div 2;
                    end
                   else
                  begin

                   if IAuftrag.left > PAnsicht.width div 2 then
                    begin
                     IAuftrag.width := PAnsicht.width - IAuftrag.left;
                    end
                   else
                    begin

                     if IAuftrag.left < PAnsicht.width div 2 then
                      begin
                       IAuftrag.width := PAnsicht.width - IAuftrag.left;
                      end;

                    end;

                  end;
               end
           else
             begin

             // 4 Der Auftrag geht durch
              if (FDMemTable1.FieldByName('ABDATUM').asdatetime <
               strtodate(EDDatum.text)) and
               (FDMemTable1.FieldByName('BISDATUM').asdatetime >
                (strtodate(EDDatum.text) + 366)) then
               begin

                //IAuftrag.stretch := false;
                IAuftrag.left := 0;
                IAuftrag.width := PAnsicht.width;

               end;

             end;
         end;
      end;





    // Die Auftraghöhe wird festgelegt
    iAuftrag.height := Auftraghoehe;
    // Die Auftrags top Koordinaten werden übergeben
    // Sie werden nach jedem neu erzeugten Auftrag erweitert sodass die Auftraege untereinander stehen
    iAuftrag.Top := trunc((btntagesansicht.Height * 2 +(BTNTagesansicht.Height div 4) + IAuftrag.Height) + ((IAuftrag.Height * 2)) * (FDMemTable1.FieldByName('ID').AsInteger - 1)) ;
    // Wenn ein auftrag während der Laufzeit nach oben oder unten verschoben wurde dann rutscht der Stati wert in der Memtable auf 1
    // Dadurch werden von der Höhe veränderte auftraege mit dem veraenderten Wert neu zugewiesen
    if   FDMemTable1.fieldbyname('YHKO').AsInteger <> 0 then
     begin
      if  FDMemTable1.FieldByName('stati').Value = '1' then
       begin
         IAuftrag.top := FDMemTable1.FieldByName('YHKO').value;
       end;
     end;




    // _____________________________________________________________________________________________________________________________________
   // Der Name des Auftrags wird zugewiesen mit 'Auftrag' und der einmal gekennzeichneten aus der Tabelle entnommenen ID
    IAuftrag.name := 'Auftrag' + (FDMemTable1.FieldByName('ID').asstring);
    // Die Maximale Farbmoeglichkeit des Auftrags wird fest gelegt
    //IAuftrag.Max := (FDMemTable1.FieldByName('MENGE').AsInteger);
    // Die Position der zu färbenden Position wird festgelegt
    //IAuftrag.Position :=  (FDMemTable1.FieldByName('GESLMENGE').AsInteger);
   // iauftrag.canvas.pen.Color := clblue;
  //    iauftrag.Canvas.Rectangle(iauftrag.Left,iauftrag.top,iauftrag.Width,iauftrag.Height) ;
    // Die Startfarbe des Auftrags und Endfarbe wird hier übergeben
    // Man kann aber auch dies als Feature noch einbauen
     //iauftrag.BarColorFrom := StrToInt( auftragfarbe1);
    // IAuftrag.BarColorTo := StrToInt( auftragfarbe1);

    //iauftrag.Max := (FDMemTable1.FieldByName('MENGE').AsInteger);
   // iauftrag.Progress := 50;
   //  iauftrag.Color2 :=  StrToInt( auftragfarbe1);

  // IAuftrag.Step := (FDMemTable1.FieldByName('GESLMENGE').AsInteger);
    /////////IAuftrag.Position := (FDMemTable1.FieldByName('GESLMENGE').AsInteger);

   {iauftrag.ForeColor := StrToInt( auftragfarbe1);
   IAuftrag.BackColor := clwhite;}

   //iauftrag.Smooth := true;
   iauftrag.color := clInactiveCaption;
   //iauftrag.BarColorFrom :=  StrToInt( auftragfarbe1);
   //IAuftrag.BarColorTo :=   StrToInt( auftragfarbe1);


    // Events werden festgelegt zum per Maus verschiebbaren Auftraegen
    IAuftrag.OnMouseDown := AuftragMouseDown;
    IAuftrag.OnMouseMove := AuftragMouseMove;

    //IAuftrag.OnMouseLeave := Auftragverlassen;
   // iauftrag.OnEndDrag := Auftragenddrag;
    LabelAuftrag := Tlabel.Create(self);

    // ______________________________________________________________________________
    // Eigenschaften des erzeugten Labels
    with LabelAuftrag do
    begin
      LabelAuftrag.Font.Size := BTNTagesansicht.Font.Size;
      // Struktur zuweisung des Labels
      Parent := Scrollganttbox;

      Caption :=

        (FDMemTable1.FieldByName('H1').asstring) + #13#10 +
        (FDMemTable1.FieldByName('H2').asstring) + #13#10 +
        (FDMemTable1.FieldByName('H3').asstring) + #13#10 {+
        inttostr(((FDMemTable1.FieldByName('GESLMENGE').AsInteger) *
        100 div (FDMemTable1.FieldByName('MENGE').AsInteger))) + '%' <- wenn man möchte das der
         Prozentuale Anteil der gefüllten Menge angezeigt werden soll};

         // Der Name des Labels das über dem Auftrag haengt wird mit 'Labelauftrag' & der
         //Einmalig gekennzeichneten ID befüllt
      name := 'Labelauftrag' + (FDMemTable1.FieldByName('ID').asstring);
      // Die Left koordinate wird auf dessen Auftrag gesetzt
      left := trunc(IAuftrag.left);
      // Die Top Koordinate des Labels wird auf dessen Auftrag Positioniert
       top := ((IAuftrag.top - LabelAuftrag.Height)+(LabelAuftrag.Height div 4));
      // Das Label wird hier sichtbar gemacht
      visible := true;

    end;

    IAuftrag.bringtofront;
    LabelAuftrag.bringtofront;


    // 5 & 6 Wenn der Auftrag mit anfang und ende kleiner als edd
    if (FDMemTable1.FieldByName('ABDATUM').asdatetime < strtodate(EDDatum.text))
      and ((((FDMemTable1.FieldByName('MENGE').AsInteger) div 24) +
      (FDMemTable1.FieldByName('ABDATUM').asdatetime)) <
      (strtodate(EDDatum.text))) or
      (FDMemTable1.FieldByName('ABDATUM').asdatetime >=
      (strtodate(EDDatum.text) + 366)) and
      ((((FDMemTable1.FieldByName('MENGE').AsInteger) div 24) +
      (FDMemTable1.FieldByName('ABDATUM').asdatetime)) >=
      (strtodate(EDDatum.text) + 366))

    then
    begin
      // Der Platz der erstellten Labels und Images die nicht zu sehen sein sollten
      // werden frei gegeben.
      IAuftrag.free;
      LabelAuftrag.free;
    end;
    // bringt den Auftrag mit dessen Label in den Fordergrund


    // Die While Schleife geht von vorne durch mit dem nächsten Datensatz
    FDMemTable1.Next;
  end;
   // Wenn die vertikale Scrollbar sichtbar ist, wird die Scrollposition angepasst
   // Da es sonst beim nicht neu Positionieren zu einem Positionierungsfehler der Scrollbar führt
    with NeuScrollbar do
 begin

    NeuScrollbar.Max := AnsichtFaktor;
    NeuScrollbar.Min := 0;
    // scrollganttbox.HorzScrollBar.size := btntagesansicht.Width * 2;
    visible := true;
    // Die Maximale Reichweite der Scrollbar wird jeder Anzeige angepasst
    if BoolTagesansicht = true then
    begin
      NeuScrollbar.Max := Scrollganttbox.HorzScrollBar.range +
        (Scrollganttbox.width div 24);
      PageSize := trunc((Scrollganttbox.width div 24));
    end;

    if (boolMonatsansicht = true) then
    begin
      NeuScrollbar.Max := Scrollganttbox.HorzScrollBar.range;
      PageSize := pansicht.Width * 31 div 366;
    end;

    if booljahresansicht =  true then
    begin
      NeuScrollbar.max := ansichtfaktor;
      scrollganttbox.HorzScrollBar.Visible := false;
      NeuScrollbar.Visible := false;

    end;


    Parent := FOGantt;
    left   := Scrollganttbox.left;
    width  := Scrollganttbox.width;
    height := Scrollganttbox.height div 25;
    top    := panelMitte.Top + panelMitte.Height - NeuScrollbar.Height;

  end;

  if Scrollganttbox.VertScrollBar.Visible = true then
  begin
   Scrollganttbox.VertScrollBar.Position:=  vertscrollpos;
  end;

  if pansicht.Height < scrollganttbox.Height then
  begin
    pansicht.Height := scrollganttbox.Height;
  end;

  // Die Position der Horizontalen Scrollbar wird neu Positnioniert für den
  // fall eines wechsels der Ansicht
  Scrollganttbox.HorzScrollBar.Position :=
    trunc((PAnsicht.width * LeftinTage)) div 366;
  // Event zuweisung der Paintbox

  PAnsicht.OnPaint := Ansichtpaint;
  PAnsicht.OnMouseMove := PansichtMousemove;
 // Die Position der darüberliegenden Scrollbar wird von der darunter liegenden angepasst
  NeuScrollbar.Position := Scrollganttbox.HorzScrollBar.Position;

end;

/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////

procedure TFOGantt.NeuScrollbarScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
// Der Fokus des Buttons wird ausgewählt anhand der aktuellen angezeigten Ansicht
  if BoolTagesansicht = true then
  begin
    BTNTagesansicht.SetFocus;

  end;

  if boolMonatsansicht = true then
  begin
    BTNMonatsansicht.SetFocus;

  end;

  if boolJahresansicht = true then
  begin
    BTNJahresansicht.SetFocus;

  end;
   // Die Scrollbarposition wird gespeichert für Ansichtenwechsel
  LeftinTage := ((366 * NeuScrollbar.Position) div AnsichtFaktor);
  // Die darüberliegende Horizontale Scrollbar wird die Neue Position Hinzugewiesen.
  NeuScrollbar.Position := trunc((Pansicht.Width * LeftinTage)) div 366;
   // der darunter liegenden horizontalen scrollbar wird die position der darüber liegenden zugewiesen sodass
   // sie sich immer gleich verschieben
  Scrollganttbox.HorzScrollBar.Position := NeuScrollbar.Position;



end;

/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////

procedure TFOGantt.BTNJahresansichtClick(Sender: TObject);
begin
// Die Boolischen Werte nach dem sich z.b das OnPaint event der Painbox richtet werden eingestellt
  boolJahresansicht := true;
  BoolTagesansicht := false;
  boolMonatsansicht := false;

// Der Faktor für die Jahresansicht wird bereitgestellt
  AnsichtFaktor := Scrollganttbox.width;

 // Die Prozedur für die Erstellung der Aufträge wird gestartet
  Auftraegeerstellen;

end;

/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
///

procedure TFOGantt.AuftragMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Differenzx, differenzy: Integer;
  i, a1,  auftragfarbe : Integer;
      AbStunden, ABMinuten , Bisminuten,bisstunden, minutendavor , stundendrüber, UHRdavor: integer;


begin

      // ___________//____________//__________//_____width kleiner groeßer_________//_________//_________//____________//_________//
   if ssLeft in shift then
   begin

      if bauftragwidthgroeßerkleiner = true then
      begin
       // Der Cursor bekommt eine andere Anzeige
       screen.Cursor := crSizeWE;
       if (Sender as TLadebalkenChat1    ).width <= 0 then
       begin

        // (Sender as TLadebalkenChat1    ).width := 1;

       end else
           begin


        // ___________//____________//__________//_____width groeßer (rechts)_________//_________//_________//____________//_________//
             if X < Downpoint.X then
              begin
                (Sender as TLadebalkenChat1    ).width := X;
              end;
              // ___________//____________//__________//_____width groeßer (rechts)_________//_________//_________//____________//_________//
              if X > Downpoint.X then
              begin
                (Sender as TLadebalkenChat1    ).width := X;
               end;
           end;
      end;
      if bauftragleftgroeßerkleiner = true then
      begin
       screen.Cursor := crSizeWE;
        // ___________//____________//__________//_____Left groeßer (rechts) __________//_________//_________//____________//_________//
        if X > Downpoint.X then
        begin
          Differenzx := X - Downpoint.X;
          (Sender as TLadebalkenChat1    ).width := (Sender as TLadebalkenChat1    ).width - Differenzx;
          (Sender as TLadebalkenChat1    ).left := (Sender as TLadebalkenChat1    ).left + Differenzx;
        end;
        // ___________//____________//__________//_____Left kleiner (links) __________//_________//_________//____________//_________//
        if Downpoint.X > X then
        begin
          Differenzx := Downpoint.X - X;
          (Sender as TLadebalkenChat1    ).width := (Sender as TLadebalkenChat1    ).width + Differenzx;
          (Sender as TLadebalkenChat1    ).left := (Sender as TLadebalkenChat1    ).left - Differenzx;
        end;
      end;
      // __________________________gesamter Auftrag nach links oder rechts verschieben____________________________________________________
      // Wenn Mausklick in shift und Mauspunkt groeßer istgleich 30% vom button Tagesansicht.breite sowie kleiner als breite - die 30%
      if bauftragverschieben = true then
      begin
      // der Cursor bekommt eine andere Anzeige
        screen.Cursor := crSizeAll;
        //Wenn der Auftrag nach rechts verschoben wird
        if X > Downpoint.X then
        begin
          Differenzx := X - Downpoint.X;
          (Sender as TLadebalkenChat1    ).left := (Sender as TLadebalkenChat1    ).left + Differenzx;
        end;
        // wenn der Auftrag nach Links verschoben wird
        if X < Downpoint.X then
        begin
          Differenzx := Downpoint.X - X;
          (Sender as TLadebalkenChat1    ).left := (Sender as TLadebalkenChat1    ).left - Differenzx;
        end;
      end;
      // wenn der Auftrag nach oben oder unten verschoben wird
      if Y < Downpoint.Y then
      begin
        differenzy := Downpoint.Y - Y;
        if (Sender as TLadebalkenChat1    ).top <= trunc(screen.DesktopHeight div 20) then
        begin
          (Sender as TLadebalkenChat1    ).top := trunc(screen.DesktopHeight div 20);
        end
        else
         begin
          // ______________________________________________________________________________
          // Grenze dass, der (Auftrag) nicht nach oben das fenster verlassen kann
          if (Sender as TLadebalkenChat1    ).top >= trunc(screen.DesktopHeight div 20) then
          begin
            (Sender as TLadebalkenChat1    ).top := (Sender as TLadebalkenChat1    ).top - differenzy;
          end;
         end;
      end;

        // Wenn der Auftrag nach unten geschoben wird
          if Y > Downpoint.Y then
          begin

            // ______________________________________________________________________________
            if ((Sender as TLadebalkenChat1    ).top + (Sender as TLadebalkenChat1    ).height) <= PAnsicht.height
            then
            begin


              differenzy := Y - Downpoint.Y;
              (Sender as TLadebalkenChat1    ).top := (Sender as TLadebalkenChat1    ).top + differenzy;

            end
            else
            begin

             // eine Grenze sodass, der Auftrag nicht zu weit nach unten verschwinden kann
              if ((Sender as TLadebalkenChat1    ).top + (Sender as TLadebalkenChat1    ).height) >
                PAnsicht.height then
              begin

              end;

            end;

          end;
      // Hier werden die Labels die an den Auftraegen haengen neu koordiniert sodass sie am Auftrag bleiben
     ((FindComponent('labelauftrag' + copy(((Sender as TLadebalkenChat1    ).name), 8, length((Sender as TLadebalkenChat1    ).name)) )) as Tlabel).BringToFront;
     ((FindComponent('labelauftrag' + copy(((Sender as TLadebalkenChat1    ).name), 8, length((Sender as TLadebalkenChat1    ).name)) )) as Tlabel).left := (Sender as TLadebalkenChat1    ).left;
     ((FindComponent('labelauftrag' + copy(((Sender as TLadebalkenChat1    ).name), 8, length((Sender as TLadebalkenChat1    ).name)) )) as Tlabel).top :=( (Sender as TLadebalkenChat1    ).top -  ((FindComponent('labelauftrag' + copy(((Sender as TLadebalkenChat1    ).name), 8, length((Sender as TLadebalkenChat1    ).name)) )) as Tlabel).Height)+ ((FindComponent('labelauftrag' + copy(((Sender as TLadebalkenChat1    ).name), 8, length((Sender as TLadebalkenChat1    ).name)) )) as Tlabel).Height div 4  ;


     // Die Memtable wird geöffnet und in den Schreibbaren Modus versetzt
     FDMemTable1.Open();
     FDMemTable1.edit;

        if   (FDMemTable1.Locate('ID', copy(((Sender as TLadebalkenChat1    ).name), 8,
         length((Sender as TLadebalkenChat1    ).name))      )) then
         begin
         // Nach locate muss man die Memtable nochmal in den Editmodus versetzen
          FDMemTable1.edit;

           // Wenn die Vertikale Scrollbar zu sehen ist werden die Aufträge mit der Position der scrollbar gespeichert, sodass sich diese immer richtig positionieren
             if Scrollganttbox.VertScrollBar.Visible = true  then
              begin
              // Die Position der Vertikalen Scrollbar muss mitgehen da sonst ein falscher wert(Koordinate) übergeben wird
               FDMemTable1.FieldByName('YHKO').Value :=  (sender as TLadebalkenChat1    ).top + Scrollganttbox.VertScrollBar.Position;
              end else
              begin
               // hier wird die Top Koordinate des Bewegten Auftrags fest gehalten
               FDMemTable1.FieldByName('YHKO').Value := (sender as TLadebalkenChat1    ).top;

              end;

                FDMemTable1.FieldByName('stati').Value := '1';

                  // hier erden Anfangs & Enddatum neu berechnet & in der Memtable Akutalisiert


                   FDMemTable1.FieldByName('ABDATUM').Value := strtodate(EDDatum.text) +
                   (((367 * scrollganttbox.HorzScrollBar.Position) div AnsichtFaktor) +
                   (((366 * (Sender as TLadebalkenChat1    ).left) div AnsichtFaktor)   )  ) ;

                   FDMemTable1.FieldByName('BISDATUM').Value :=strtodate(EDDatum.text) +
                   (((367 * NeuScrollbar.Position) div AnsichtFaktor) +
                   ((trunc(366 *( (Sender as TLadebalkenChat1    ).left + (sender as TLadebalkenChat1    ).Width )) div AnsichtFaktor)));



           if booltagesansicht = true then
           begin



                   Abstunden :=  trunc( (Sender as TLadebalkenChat1).left * 1440 div scrollganttbox.Width div 60)  ;
                   AbMinuten :=  trunc((((Sender as TLadebalkenChat1).left * 1440) div scrollganttbox.Width )  -  (Abstunden * 60));

                   bisstunden :=  trunc(((Sender as TLadebalkenChat1).width - (((Sender as TLadebalkenChat1    ).left  - ( (Sender as TLadebalkenChat1    ).left * 2)) ))  * 1440 div scrollganttbox.Width div 60);
                   bisMinuten :=  trunc(((( (Sender as TLadebalkenChat1).width - (((Sender as TLadebalkenChat1    ).left  - ( (Sender as TLadebalkenChat1    ).left * 2)) ))  * 1440) div scrollganttbox.Width )  -  (bisstunden * 60));

                   minutendavor := ABMinuten;
                   minutendavor := ABMinuten - (ABMinuten * 2);
                   minutendavor := 59 - minutendavor;
                  // Stundendrüber ist die berechnung der Uhrzeit -> Auftragsende das nicht zu sehen ist nach gesamten verschieben
                   stundendrüber := bisstunden div 24;
                   stundendrüber  := stundendrüber * 24;
                   stundendrüber := bisstunden - stundendrüber;

                   UHRdavor := AbStunden  div 24;
                   UHRdavor :=  UHRdavor * 24;
                   UHRdavor := AbStunden - UHRdavor ;
                   UHRdavor := UHRdavor - (UHRdavor * 2);
                   UHRdavor := 23 - UHRdavor;




                   // Wenn Auftraganfang und Auftragende über die Sichtfelder hinaus gehen
                   if (AbStunden < 0) and (ABMinuten < 0) and (bisstunden > 23) then
                   begin

                      FDMemTable1.FieldByName('ABUHR').AsDateTime :=
                        StrToTime( inttostr( UHRdavor) +':'+ inttostr(minutendavor)) ;

                      FDMemTable1.FieldByName('BISUHR').AsDateTime :=
                        StrToTime( inttostr( stundendrüber) +':'+ inttostr(bisMinuten)) ;

                   end;

                   // Wenn das Anfangsdatum des Auftrags hinter der Ansicht ist und das Ende innerhalb
                   if (AbStunden < 0 ) and (ABMinuten < 0) and (bisstunden <= 23 ) then
                   begin

                        FDMemTable1.FieldByName('ABUHR').AsDateTime :=
                        StrToTime( inttostr( UHRdavor) +':'+ inttostr(minutendavor)) ;

                        FDMemTable1.FieldByName('BISUHR').AsDateTime :=
                        StrToTime( inttostr( bisstunden) +':'+ inttostr(bisMinuten)) ;

                   end;

                   // Wenn der Anfang des Auftrags innerhalb des Sichtfeldes liegt & das ende außerhalb
                   if (AbStunden >= 0) and (ABMinuten >=0) and (AbStunden < 23) and (bisstunden > 23)then
                   begin

                     FDMemTable1.FieldByName('ABUHR').AsDateTime :=
                        StrToTime( inttostr( AbStunden) +':'+ inttostr(ABMinuten)) ;

                      FDMemTable1.FieldByName('BISUHR').AsDateTime :=
                        StrToTime( inttostr( stundendrüber) +':'+ inttostr(bisMinuten)) ;

                   end;

                   // Wenn anfang und ende innerhalb des Sichtfeldes(des Tages) liegt
                   if (AbStunden >= 0) and (abstunden <= 23) and (ABMinuten >=0) and (bisstunden <= 23) then
                   begin

                      FDMemTable1.FieldByName('ABUHR').AsDateTime :=
                        StrToTime( inttostr( AbStunden) +':'+ inttostr(ABMinuten)) ;

                      FDMemTable1.FieldByName('BISUHR').AsDateTime :=
                        StrToTime( inttostr( bisstunden) +':'+ inttostr(bisMinuten)) ;


                   end;



                   {if (AbStunden < 0) and (ABMinuten < 0) and (bisstunden <= 23) then
                   begin



                   end;}








           end;
         end;

        // Mit Post werden die geänderten Daten in die Memtable übergeben
        FDMemTable1.Post;

    end else
       begin
           // Nach loslassen der linken Maustaste werden die Positionen der Maus auf dem jeweiligen Auftrag
           // wieder durch die boolischen werte zurückgesetzt & die Anzeige der Maus springt wieder in den
           // Standart zurück
           bauftragverschieben := false;
           bauftragleftgroeßerkleiner := false;
           bauftragwidthgroeßerkleiner := false;
           Screen.Cursor := crDefault;

       end;


     if Auftragmarkiert = true then
     begin
     ((FindComponent(AusgewaehlterAuftrag)) as TLadebalkenChat1).BringToFront;
     end;



     // Lässt das Verschieben der Aufträge flüssiger werden
    Scrollganttbox.DoubleBuffered := true;
     Scrollganttbox.Refresh;

 end;



/// //////////////////////////////////////////Prozedur/////////////////////////////////////////////
procedure TFOGantt.Ansichtpaint(Sender: TObject);
 begin

    // Die Anzeige die gerade Aktiv ist wird dessen Prozedur zum Zeichnen verwendet
  if boolJahresansicht = true then
   begin
    AnzeigeJahr;
   end;

  if boolMonatsansicht = True then
   begin
    AnzeigeMonat;
   end;

  if BoolTagesansicht = true then
   begin
    Anzeigetag;

   end;

   Markieren;

  end;

end.


