{ coreutils, dpkg, fetchurl, file, ghostscript, gnugrep, gnused,
makeWrapper, perl, pkgs, stdenv, which }:

stdenv.mkDerivation rec {
  name = "mfcl8690cdwlpr-${version}";
  version = "1.2.0-0";

  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf103241/${name}.i386.deb";
    sha256 = "02k43nh51pn4lf7gaid9yhil0a3ikpy4krw7dhgphmm5pap907sx";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    dpkg-deb -x $src $out

    dir=$out/opt/brother/Printers/mfcl8690cdw
    filter=$dir/lpd/filter_mfcl8690cdw

    substituteInPlace $filter \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfcl8690cdw\"; #"

    wrapProgram $filter \
      --prefix PATH : ${stdenv.lib.makeBinPath [
      coreutils file ghostscript gnugrep gnused which
      ]}

    # need to use i686 glibc here, these are 32bit proprietary binaries
    interpreter=${pkgs.pkgsi686Linux.glibc}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" $dir/lpd/brmfcl8690cdwfilter
  '';

  meta = {
    description = "Brother MFC-L8690CDW LPR printer driver";
    homepage = http://www.brother.com/;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.fuzzy-id ];
    platforms = [ "i686-linux" ];
  };
}
