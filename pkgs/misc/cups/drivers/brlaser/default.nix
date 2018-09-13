{ stdenv, fetchFromGitHub, cmake, zlib, cups }:

stdenv.mkDerivation rec {
  name = "brlaser-${version}";
  version = "4";

  src = fetchFromGitHub {
    owner = "pdewacht";
    repo = "brlaser";
    rev = "v${version}";
    sha256 = "1yy4mpf68c82h245srh2sd1yip29w6kx14gxk4hxkv496gf55lw5";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib cups ];

  cmakeFlags = [ "-DCUPS_SERVER_BIN=$out/lib/cups" "-DCUPS_DATA_DIR=$out/share/cups" ];

  meta = with stdenv.lib; {
    description = "A CUPS driver for Brother laser printers";
    longDescription =
      ''
       Although most Brother printers support a standard printer language such as PCL or PostScript, not all do. If you have a monochrome Brother laser printer (or multi-function device) and the other open source drivers don't work, this one might help.

       This driver is known to work with these printers:

           Brother DCP-1510
           Brother DCP-7030
           Brother DCP-7040
           Brother DCP-7055
           Brother DCP-7055W
           Brother DCP-7065DN
           Brother HL-L2300D
           Brother MFC-7360N
      '';
    homepage = https://github.com/pdewacht/brlaser;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ StijnDW ];
  };
}
