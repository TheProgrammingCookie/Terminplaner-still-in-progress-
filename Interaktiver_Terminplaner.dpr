program Interaktiver_Terminplaner;

uses
  Vcl.Forms,
  UnitTerminKalender in 'UnitTerminKalender.pas' {FOGantt},
  Vcl.Themes,
  Vcl.Styles,
  GGAUGE in 'Progressbar\GGAUGE.PAS',
  BProgressBar in 'Progressbar\BProgressBar.pas',
  LAdebalkenChat in 'Progressbar\neu\LAdebalkenChat.pas' {LadebalkenChat1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFOGantt, FOGantt);
  Application.CreateForm(TLadebalkenChat1, LadebalkenChat1);
  Application.Run;
end.
