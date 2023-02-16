unit SpeichernFrageModalFenster;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,unit1;

type
  TFSpeichern = class(TForm)
    PanelMitte: TPanel;
    BTNAbbruch: TButton;
    LAbfrage: TLabel;
    BTNExtDatei: TButton;
    BTNInDatenbank: TButton;

    procedure BTNAbbruchClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BTNInDatenbankClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FSpeichern: TFSpeichern;

implementation


{$R *.dfm}

 procedure tfspeichern.BTNInDatenbankClick(Sender: TObject);
 begin

  FSpeichern.Close;

  with FOGantt do
  begin


   TBLQuery.Open();


     with FDMemTable1 do
     begin

       while (fdmemtable1.Locate('Stati' ,  '1',[]   )=true)  do
       begin

       //howmessage('Daten schreiben');

         TBLQuery.Locate('ID', FDMemTable1.FieldByName('ID').Value);
             TBLQuery.Edit;
         TBLQuery.FieldByName('AbDatum').Value := FDMemTable1.FieldByName('Abdatum').Value;
         TBLQuery.FieldByName('bisdatum').Value := FDMemTable1.FieldByName('bisdatum').Value;
         TBLQuery.FieldByName('bisuhr').Value := FDMemTable1.FieldByName('bisuhr').Value;
         TBLQuery.FieldByName('abuhr').Value := FDMemTable1.FieldByName('abuhr').Value;
         Edit;
         FieldByName('stati').asstring:='';
          post;
        TBLQuery.Post;
       end;

       Exit;


     end;





  end;


 end;

procedure TFSpeichern.BTNAbbruchClick(Sender: TObject);
begin
 FSpeichern.Close;
end;



procedure TFSpeichern.FormActivate(Sender: TObject);
begin

  with FSpeichern do
  begin
   width := Screen.DesktopWidth div 4;
   height := Screen.DesktopHeight div 4;
   top := (screen.Height div 3 ) - (Height div 2);
   left := (screen.Width div 2 ) - (width div 2);
  end;

  with BTNAbbruch do
  begin
    width := PanelMitte.Width div 6;
    Height := PanelMitte.Height  div 8 ;
    left := PanelMitte.Width - (BTNAbbruch.Width + (BTNAbbruch.Height div 3)  );
    top := PanelMitte.Height - (BTNAbbruch.Height +(BTNAbbruch.Height div 3) );
  end;



  with BTNInDatenbank do
  begin
    width := BTNAbbruch.Width * 2 ;
    Height := BTNAbbruch.Height;
    top := (PanelMitte.Height div 2) - (BTNInDatenbank.Height );
    Left := (PanelMitte.Width div 2) - (BTNInDatenbank.Width + ((BTNInDatenbank.width div 2) -BTNInDatenbank.width div 3 )) ;
  end;

  with BTNExtDatei do
  begin
    width := BTNAbbruch.Width * 2;
    Height := BTNAbbruch.Height;
    top := BTNInDatenbank.Top;
    left :=  (PanelMitte.Width div 2 ) + ( (PanelMitte.Width div 2 ) - (BTNInDatenbank.Left + BTNInDatenbank.Width)   )  ;
  end;



   with LAbfrage do
  begin
   top :=  BTNInDatenbank.Top - (BTNInDatenbank.Height * 2);
    Left := (PanelMitte.Width div 2  ) -( LAbfrage.Width div 2) ;
  end;




end;

end.
