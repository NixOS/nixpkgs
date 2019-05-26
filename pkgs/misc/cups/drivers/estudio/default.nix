{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "cups-toshiba-estudio-${version}";
  version = "7.89";

  src = fetchurl {
    url = http://business.toshiba.com/downloads/KB/f1Ulds/15178/TOSHIBA_ColorMFP_CUPS.tar;
    sha256 = "0qz4r7q55i0adf4fv3aqnfqgi2pz3jb1jixkqm9x6nk4vanyjf4r";
  };

  buildInputs = [ perl ];

  phases = [ "unpackPhase"
             "patchPhase"
             "installPhase" ];

  patchPhase = ''
    patchShebangs lib/
    gunzip                share/cups/model/Toshiba/TOSHIBA_ColorMFP_CUPS.gz
    sed -i "s+/usr+$out+" share/cups/model/Toshiba/TOSHIBA_ColorMFP_CUPS
    gzip                  share/cups/model/Toshiba/TOSHIBA_ColorMFP_CUPS
  '';

  installPhase = ''
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model/Toshiba
    cp {.,$out}/lib/cups/filter/est6550_Authentication
    chmod 755 $out/lib/cups/filter/est6550_Authentication
    cp {.,$out}/share/cups/model/Toshiba/TOSHIBA_ColorMFP_CUPS.gz
    chmod 755 $out/share/cups/model/Toshiba/TOSHIBA_ColorMFP_CUPS.gz
  '';

  meta = with stdenv.lib; {
    description = "Printer only driver for the Toshiba e-STUDIO class of printers";
    longDescription = ''
      This driver supports the following printers: TOSHIBA e-STUDIO2000AC,
      TOSHIBA e-STUDIO2005AC, TOSHIBA e-STUDIO2040C, TOSHIBA e-STUDIO2050C,
      TOSHIBA e-STUDIO2055C, TOSHIBA e-STUDIO2500AC, TOSHIBA e-STUDIO2505AC,
      TOSHIBA e-STUDIO2540C, TOSHIBA e-STUDIO2550C, TOSHIBA e-STUDIO2555C,
      TOSHIBA e-STUDIO287CS, TOSHIBA e-STUDIO3005AC, TOSHIBA e-STUDIO3040C,
      TOSHIBA e-STUDIO3055C, TOSHIBA e-STUDIO347CS, TOSHIBA e-STUDIO3505AC,
      TOSHIBA e-STUDIO3540C, TOSHIBA e-STUDIO3555C, TOSHIBA e-STUDIO407CS,
      TOSHIBA e-STUDIO4505AC, TOSHIBA e-STUDIO4540C, TOSHIBA e-STUDIO4555C,
      TOSHIBA e-STUDIO5005AC, TOSHIBA e-STUDIO5055C, TOSHIBA e-STUDIO5506AC,
      TOSHIBA e-STUDIO5540C, TOSHIBA e-STUDIO5560C, TOSHIBA e-STUDIO6506AC,
      TOSHIBA e-STUDIO6540C, TOSHIBA e-STUDIO6550C, TOSHIBA e-STUDIO6560C,
      TOSHIBA e-STUDIO6570C and TOSHIBA e-STUDIO7506AC.
    '';
    homepage = http://business.toshiba.com/support/downloads/index.html;
    license = licenses.unfree;
    maintainers = [ maintainers.jpotier ];
  };
}
