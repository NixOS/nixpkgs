{ stdenv, fetchFromGitHub, cmake, zlib, cups }:

stdenv.mkDerivation rec {
  pname = "brlaser";
  version = "6";

  src = fetchFromGitHub {
    owner = "pdewacht";
    repo = "brlaser";
    rev = "v${version}";
    sha256 = "1995s69ksq1fz0vb34v0ndiqncrinbrlpmp70rkl6az7kag99s80";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib cups ];

  cmakeFlags = [ "-DCUPS_SERVER_BIN=lib/cups" "-DCUPS_DATA_DIR=share/cups" ];

  meta = with stdenv.lib; {
    description = "A CUPS driver for Brother laser printers";
    longDescription =
      ''
       Although most Brother printers support a standard printer language such as PCL or PostScript, not all do. If you have a monochrome Brother laser printer (or multi-function device) and the other open source drivers don't work, this one might help.

       This driver is known to work with these printers:

           Brother DCP-1510
           Brother DCP-1602
           Brother DCP-7030
           Brother DCP-7040
           Brother DCP-7055
           Brother DCP-7055W
           Brother DCP-7060D
           Brother DCP-7065DN
           Brother DCP-7080
           Brother DCP-L2500D
           Brother DCP-L2520D
           Brother DCP-L2540DW
           Brother HL-1110
           Brother HL-1200
           Brother HL-2030
           Brother HL-2140
           Brother HL-2220
           Brother HL-2270DW
           Brother HL-5030
           Brother HL-L2300D
           Brother HL-L2320D
           Brother HL-L2340D
           Brother HL-L2360D
           Brother MFC-1910W
           Brother MFC-7240
           Brother MFC-7360N
           Brother MFC-7365DN
           Brother MFC-7840W
           Brother MFC-L2710DW
           Lenovo M7605D
      '';
    homepage = "https://github.com/pdewacht/brlaser";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ StijnDW ];
  };
}
