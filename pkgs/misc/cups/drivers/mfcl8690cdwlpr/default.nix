{ coreutils, dpkg, fetchurl, file, ghostscript, gnugrep, gnused,
makeWrapper, perl, pkgs, lib, stdenv, which }:

stdenv.mkDerivation rec {
  pname = "mfcl8690cdwlpr";
  version = "1.5.0-0";

  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf103241/${pname}-${version}.i386.deb";
    sha256 = "05kmw9s82xbybmglcj286ynyb581zj4l94fijdq1wljx30x9rvmj";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  dontUnpack = true;
  libPath = lib.makeLibraryPath [stdenv.cc.cc];

  installPhase = ''
    dpkg-deb -x $src $out

    dir=$out/opt/brother/Printers/mfcl8690cdw
    filter=$dir/lpd/filter_mfcl8690cdw

    substituteInPlace $filter \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfcl8690cdw\"; #"

    wrapProgram $filter \
      --prefix PATH : ${lib.makeBinPath [
      coreutils file ghostscript gnugrep gnused which
      ]}
    interpreter="$(cat $NIX_CC/nix-support/dynamic-linker)"
    patchelf --set-interpreter "$interpreter" --set-rpath "${libPath}" $dir/lpd/x86_64/brmfcl8690cdwfilter
    ln $dir/lpd/x86_64/brmfcl8690cdwfilter $dir/lpd/brmfcl8690cdwfilter
    patchelf --set-interpreter "$interpreter" $dir/lpd/x86_64/brprintconf_mfcl8690cdw
    ln $dir/lpd/x86_64/brprintconf_mfcl8690cdw $dir/lpd/brprintconf_mfcl8690cdw
  '';

  meta = {
    description = "Brother MFC-L8690CDW LPR printer driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.thomasbach-dev ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
