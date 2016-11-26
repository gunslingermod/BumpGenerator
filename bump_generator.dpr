program bump_generator;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  TextureParams in 'TextureParams.pas',
  dds in 'dds.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Bump Generator';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
