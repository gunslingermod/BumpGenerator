unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TextureParams, StdCtrls, dds, strutils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    log: TMemo;
    Edit1: TEdit;
    Label1: TLabel;
    od1: TOpenDialog;
    check_backup: TCheckBox;
    radio_bump: TRadioButton;
    radio_nmap: TRadioButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  nmap, errmap:PByte;
  w,h:cardinal;
  i:integer;
  params:STextureParams;
  f:textfile;
begin
  if not od1.Execute() then exit;

  if not TextureParams.Init then begin
    MessageBox(self.Handle, 'Could not initialize DXT.dll!', 'Error!', MB_OK+MB_ICONERROR);
    Application.Terminate();
  end;

  log.Clear();
  Button1.Enabled:=false;
  Edit1.Enabled:=false;
  check_backup.Enabled:=false;
  radio_bump.Enabled:=false;
  radio_nmap.Enabled:=false;
  log.Lines.add('Converting started, wait...');

  for i:=0 to od1.Files.Count-1 do begin
    if radio_bump.Checked then begin
      dds.LoadDDS(od1.Files.Strings[i], w,h,nmap,errmap,DDSMODE_BUMP);
    end else begin
      dds.LoadDDS(od1.Files.Strings[i], w,h,nmap,errmap,DDSMODE_NMAP);
    end;

    if errmap<>nil then begin
      if check_backup.Checked then begin
        if FileExists(od1.Files.Strings[i]+'.bak') then DeleteFile(od1.Files.Strings[i]+'.bak');
        RenameFile(od1.Files.Strings[i], od1.Files.Strings[i]+'.bak');
      end;
      params.ttype:=ETType__ttBumpMap;
      params.bump_virtual_height:=strtofloatdef(edit1.Text, 0.05);
      CompressProc(PChar(od1.Files.Strings[i]), errmap, nmap, w, h, w*4, @params, 4);
      log.Lines.add('File '+od1.Files.Strings[i]+' processed');
      assignfile(f, leftstr(od1.Files.Strings[i], length(od1.Files.Strings[i])-4)+'.thm');
      rewrite(f);
      write(f, chr($10), chr($08), chr(0), chr(0), chr($2), chr(0), chr(0), chr(0), chr($12), chr(0), chr($13), chr($8), chr(0), chr(0), chr($4), chr(0),
               chr($0), chr($0), chr($01), chr($0), chr($0), chr($0), chr($12), chr($8), chr($0), chr($0), chr($20), chr($0), chr($0), chr($0), chr($02), chr($0),
               chr($0), chr($0), chr($0), chr($1), chr($0), chr($02), chr($0), chr($0), chr($0), chr($0), chr($0), chr($0), chr($0), chr($0), chr($0), chr($0),
               chr($0), chr($0), chr($0), chr($0), chr($0), chr($0), chr($0), chr($01), chr($0), chr($0), chr($0), chr($01), chr($0), chr($0), chr($14), chr($08),
               chr($0), chr($0), chr($04), chr($0), chr($0), chr($0), chr($02), chr($0), chr($0), chr($0), chr($15),  chr($08), chr($0), chr($0), chr($05),  chr($0),
               chr($0), chr($0), chr($0), chr($0), chr($0), chr($80), chr($3F), chr($16), chr($08), chr($0), chr($0), chr($08), chr($0), chr($0), chr($0), chr($01),
               chr($0), chr($0), chr($0), chr($0), chr($0), chr($0), chr($0), chr($17), chr($08), chr($0), chr($0), chr($09), chr($0), chr($0), chr($0), chr($29),
               chr($5c), chr($0f), chr($3d), chr($01), chr($0), chr($0), chr($0), chr($0), chr($18), chr($08), chr($0), chr($0), chr($01), chr($0), chr($0), chr($0),
               chr($0), chr($19), chr($08), chr($0), chr($0), chr($01), chr($0), chr($0), chr($0), chr($0));

      closefile(f);
      FreeMem(nmap);
      FreeMem(ErrMap);
    end else begin
      log.Lines.add('ERROR: file '+od1.Files.Strings[i]+' not processed');    
    end;
  end;
  Button1.Enabled:=true;
  Edit1.Enabled:=true;
  check_backup.Enabled:=true;
  radio_bump.Enabled:=true;
  radio_nmap.Enabled:=true;

  log.Lines.add('Done!');
  TextureParams.Free;
  MessageBox(self.Handle, 'Done!', '', MB_OK+MB_ICONINFORMATION);
end;

end.
