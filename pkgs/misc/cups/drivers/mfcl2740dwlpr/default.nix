{ pkgsi686Linux, stdenv, fetchurl, dpkg, makeWrapper, coreutils, ghostscript, gnugrep, gnused, which, perl }:

stdenv.mkDerivation rec {
  pname = "mfcl2740dwlpr";
  version = "3.2.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101727/${pname}-${version}.i386.deb";
    sha256 = "10a2bc672bd54e718b478f3afc7e47d451557f7d5513167d3ad349a3d00bffaf";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  unpackPhase = "dpkg-deb -x $src $out";

  installPhase = ''
    dir=$out/opt/brother/Printers/MFCL2740DW

    substituteInPlace $dir/lpd/filter_MFCL2740DW \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
      --replace "PRINTER =~" "PRINTER = \"MFCL2740DW\"; #"

    wrapProgram $dir/lpd/filter_MFCL2740DW \
      --prefix PATH : ${stdenv.lib.makeBinPath [
        coreutils ghostscript gnugrep gnused which
      ]}

    # need to use i686 glibc here, these are 32bit proprietary binaries
    interpreter=${pkgsi686Linux.glibc}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" $dir/inf/braddprinter
    patchelf --set-interpreter "$interpreter" $dir/lpd/brprintconflsr3
    patchelf --set-interpreter "$interpreter" $dir/lpd/rawtobr3
  '';

  meta = {
    description = "Brother MFC-L2740DW lpr driver";
    homepage = http://www.brother.com/;
    license = stdenv.lib.licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.enzime ];
  };
}
