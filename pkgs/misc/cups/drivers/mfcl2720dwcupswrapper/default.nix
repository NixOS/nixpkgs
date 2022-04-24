{ lib, stdenv, fetchurl, dpkg, makeWrapper, coreutils, gnugrep, gnused, perl, mfcl2720dwlpr }:

stdenv.mkDerivation rec {
  pname = "mfcl2720dwcupswrapper";
  version = "3.2.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101802/${pname}-${version}.i386.deb";
    sha256 = "6d131926ce22c51b1854d2b91e426cc7ecbf5d6dabd698ef51a417090e35c598";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x $src $out

    basedir=${mfcl2720dwlpr}/opt/brother/Printers/MFCL2720DW
    dir=$out/opt/brother/Printers/MFCL2720DW

    substituteInPlace $dir/cupswrapper/brother_lpdwrapper_MFCL2720DW \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "basedir =~" "basedir = \"$basedir\"; #" \
      --replace "PRINTER =~" "PRINTER = \"MFCL2720DW\"; #"

    substituteInPlace $dir/cupswrapper/paperconfigml1 \
      --replace /usr/bin/perl ${perl}/bin/perl

    wrapProgram $dir/cupswrapper/brother_lpdwrapper_MFCL2720DW \
      --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep gnused ]}

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln $dir/cupswrapper/brother_lpdwrapper_MFCL2720DW $out/lib/cups/filter
    ln $dir/cupswrapper/brother-MFCL2720DW-cups-en.ppd $out/share/cups/model
  '';

  meta = {
    description = "Brother MFC-L2720DW CUPS wrapper driver";
    homepage = "http://www.brother.com/";
    license = lib.licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ lib.maintainers.xeji ];
  };
}
