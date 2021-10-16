{ coreutils, dpkg, fetchurl, gnugrep, gnused, makeWrapper, mfcj5320dwlpr, perl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "mfcj5320dwcupswrapper";
  version = "3.0.1-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101592/${pname}-${version}.i386.deb";
    sha256 = "VQcPSx+xWGZUDP8lklmf7Juz7fQ38eop2TfyUQrxXGM=";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x $src $out

    basedir=${mfcj5320dwlpr}/opt/brother/Printers/mfcj5320dw
    dir=$out/opt/brother/Printers/mfcj5320dw

    substituteInPlace $dir/cupswrapper/cupswrappermfcj5320dw \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "basedir =~" "basedir = \"$basedir\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfcj5320dw\"; #"

    wrapProgram $dir/cupswrapper/cupswrappermfcj5320dw \
      --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep gnused ]}

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln $dir/cupswrapper/cupswrappermfcj5320dw $out/lib/cups/filter
    ln $dir/cupswrapper/brcupsconfpt1 $out/lib/cups/filter
    ln $dir/cupswrapper/brother_mfcj5320dw_printer_en.ppd $out/share/cups/model
  '';

  meta = with lib; {
    description = "Brother MFC-J5320DW CUPS wrapper driver";
    homepage = "http://www.brother.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ martfont ];
  };
}
