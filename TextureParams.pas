unit TextureParams;

interface
type
  STextureParams = packed record
    fmt:cardinal;
    flags:cardinal;
    border_color:cardinal;
    fade_color:cardinal;
    fade_amount:cardinal;
    fade_delay:byte;
    mip_filter:cardinal;
    width:cardinal;
    height:cardinal;
    detail_name:pointer {shared_str};
    detail_scale:single;
    ttype:cardinal;
    material:cardinal;
    material_weight:single;
    bump_virtual_height:single;
    bump_mode:cardinal;
    bump_name:pointer {shared_str};
    ext_normal_map_name: pointer {shared_str};
  end;
  pSTextureParams = ^STextureParams;

var
  CompressProc: function(out_name:PChar; raw_data:pByte; normal_map:pByte; w:cardinal; h:cardinal; pitch:cardinal; fmt:pSTextureParams; depth:cardinal):cardinal; stdcall;

const
  ETType__ttImage: cardinal = 0;
  ETType__ttBumpMap: cardinal = 2;


function Init():boolean;
function Free():boolean;

implementation
uses windows;
var
  lib:THandle;

function Init():boolean;
begin
  lib:=LoadLibrary('DXT.dll');
  if lib<>0 then begin
    CompressProc:=GetProcAddress(lib, '_DXTCompress@32');
    result:= @CompressProc<>nil;
  end else begin
    result:=false;
  end;
end;

function Free():boolean;
begin
  if lib<>0 then begin
    FreeLibrary(lib);
    lib:=0;
    CompressProc:=nil;
  end;
end;

end.
