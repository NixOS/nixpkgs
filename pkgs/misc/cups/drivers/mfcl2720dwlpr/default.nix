{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  coreutils,
  ghostscript,
  gnugrep,
  gnused,
  which,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "mfcl2720dwlpr";
  version = "3.2.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101801/${pname}-${version}.i386.deb";
    sha256 = "088217e9ad118ec1e7f3d3f8f60f3bd839fe2c7d7c1136b249e9ac648dc742af";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x $src $out

    dir=$out/opt/brother/Printers/MFCL2720DW

    substituteInPlace $dir/lpd/filter_MFCL2720DW \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
      --replace "PRINTER =~" "PRINTER = \"MFCL2720DW\"; #"

    wrapProgram $dir/lpd/filter_MFCL2720DW \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          ghostscript
          gnugrep
          gnused
          which
        ]
      }

    # need to use i686 glibc here, these are 32bit proprietary binaries
    interpreter=${pkgs.pkgsi686Linux.glibc}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" $dir/inf/braddprinter
    patchelf --set-interpreter "$interpreter" $dir/lpd/brprintconflsr3
    patchelf --set-interpreter "$interpreter" $dir/lpd/rawtobr3
  '';

  meta = {
    description = "Brother MFC-L2720DW lpr driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ lib.maintainers.xeji ];
  };
}
