unit dds;

interface
uses Classes, SysUtils;

type dds_pixelformat = packed record
  dwSize:cardinal;
  dwFlags:cardinal;
  dwFourCC:cardinal;
  dwRGBBitCount:cardinal;
  dwRBitmask:cardinal;
  dwGBitmask:cardinal;
  dwBBitmask:cardinal;
  dwABitmask:cardinal;
end;

type dds_header = packed record
  dwSize:cardinal;
  dwFlags:cardinal;
  dwHeight:cardinal;
  dwWidth:cardinal;
  dwPitchOrLinearSize:cardinal;
  dwDepth:cardinal;
  dwMipMapCount:cardinal;
  dwReserved1:array[0..10] of Cardinal;
  ddspf:dds_pixelformat;
  dwCaps:cardinal;
  dwCaps2:cardinal;
  dwCaps3:cardinal;
  dwCaps4:cardinal;
  dwReserved2:cardinal;
end;

TDDSMODE = (DDSMODE_BUMP, DDSMODE_NMAP);

procedure LoadDDS(fname:string; var w:Cardinal; var h:Cardinal; var nmap:pByte; var errmap:pByte; mode:TDDSMODE);

implementation

const
  MAGIC:cardinal = $20534444;

  DDPF_RGB:cardinal = $40;
  DDPF_FOURCC:cardinal = $4;

  DDPF_FOURCC_DXT5:cardinal =$35545844;
  DDPF_FOURCC_DXT3:cardinal =$33545844;
  DDPF_FOURCC_DXT1:cardinal =$31545844;




procedure _LoadUnCompressedStalkerBumpDDS(str:TStream; var w:Cardinal; var h:Cardinal; var nmap:pByte; var errmap:pByte; hdr:dds_header; mode:TDDSMODE);
var
  pix_arr:array [0..3] of byte;
  x,y:cardinal;
begin
  if not ( (hdr.ddspf.dwABitmask=$FF000000) and (hdr.ddspf.dwRBitmask=$00FF0000) and (hdr.ddspf.dwGBitmask=$0000FF00) and (hdr.ddspf.dwBBitmask=$000000FF)) then begin
    nmap:=nil;
    errmap:=nil;
    exit;
  end;

  w:=hdr.dwWidth;
  h:=hdr.dwHeight;
  nmap:= AllocMem(h*w*4);
  errmap:= AllocMem(h*w*4);

  for y:=0 to hdr.dwHeight-1 do begin
    for x:=0 to hdr.dwWidth-1 do begin
      str.ReadBuffer(pix_arr[0], 4); //0-B, 1 - G, 2 - R, 3 - A;
      if mode=DDSMODE_BUMP then begin
        pByte(cardinal(nmap)+y*w*4+x*4+0)^:=pix_arr[1]; //B<--G
        pByte(cardinal(nmap)+y*w*4+x*4+1)^:=pix_arr[0]; //G<--B
        pByte(cardinal(nmap)+y*w*4+x*4+2)^:=pix_arr[3]; //R<--A
        pByte(cardinal(nmap)+y*w*4+x*4+3)^:=pix_arr[2]; //A<--R

        pByte(cardinal(errmap)+y*w*4+x*4+0)^:=128; //B
        pByte(cardinal(errmap)+y*w*4+x*4+1)^:=128; //G
        pByte(cardinal(errmap)+y*w*4+x*4+2)^:=128; //R
        pByte(cardinal(errmap)+y*w*4+x*4+3)^:=pix_arr[2];    //A<--R - specular
      end else if mode=DDSMODE_NMAP then begin
        pByte(cardinal(nmap)+y*w*4+x*4+0)^:=pix_arr[0]; //B<--B
        pByte(cardinal(nmap)+y*w*4+x*4+1)^:=pix_arr[1]; //G<--G
        pByte(cardinal(nmap)+y*w*4+x*4+2)^:=pix_arr[2]; //R<--R
        pByte(cardinal(nmap)+y*w*4+x*4+3)^:=pix_arr[3]; //A<--A

        pByte(cardinal(errmap)+y*w*4+x*4+0)^:=128; //B
        pByte(cardinal(errmap)+y*w*4+x*4+1)^:=128; //G
        pByte(cardinal(errmap)+y*w*4+x*4+2)^:=128; //R
        pByte(cardinal(errmap)+y*w*4+x*4+3)^:=pix_arr[3];    //A<--A - specular
      end;


    end;
  end;

end;

procedure LoadDDS(fname:string; var w:Cardinal; var h:Cardinal; var nmap:pByte; var errmap:pByte; mode:TDDSMODE);
var
  tmp:cardinal;
  hdr:dds_header;
  str:TFileStream;
begin
  str:=TFileStream.Create(fname, fmOpenRead);
  try
    str.ReadBuffer(tmp, sizeof(tmp));
    if MAGIC<>tmp then raise EStreamError.Create('Invalid Magic in DDS Header!');

    str.ReadBuffer(hdr, sizeof(hdr));
    if hdr.dwSize<>124 then raise EStreamError.Create('Invalid dds_header.dwSize!');
    if hdr.ddspf.dwSize<>32 then raise EStreamError.Create('Invalid dds_pixelformat.dwSize!');

    if (hdr.ddspf.dwFlags and DDPF_RGB)>0 then begin
      _LoadUnCompressedStalkerBumpDDS(str, w, h, nmap, errmap, hdr, mode);
    end else begin
      nmap:=nil;
      errmap:=nil;
    end;
  finally
    str.Free();
  end;

end;

end.
