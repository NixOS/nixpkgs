{ coreutils, dpkg, fetchurl, ghostscript, gnugrep, gnused, makeWrapper, perl, stdenv, which }:

stdenv.mkDerivation rec {
  name = "mfcl2700dnlpr-${version}";
  version = "3.2.0-1";

  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf102085/${name}.i386.deb";
    sha256 = "170qdzxlqikzvv2wphvfb37m19mn13az4aj88md87ka3rl5knk4m";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    dpkg-deb -x $src $out

    dir=$out/opt/brother/Printers/MFCL2700DN

    substituteInPlace $dir/lpd/filter_MFCL2700DN \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
      --replace "PRINTER =~" "PRINTER = \"MFCL2700DN\"; #"

    wrapProgram $dir/lpd/filter_MFCL2700DN \
      --prefix PATH : ${stdenv.lib.makeBinPath [
        coreutils ghostscript gnugrep gnused which
      ]}

    interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
    patchelf --set-interpreter "$interpreter" $dir/inf/braddprinter
    patchelf --set-interpreter "$interpreter" $dir/lpd/brprintconflsr3
    patchelf --set-interpreter "$interpreter" $dir/lpd/rawtobr3
  '';

  meta = {
    description = "Brother MFC-L2700DN LPR driver";
    homepage = "http://www.brother.com/";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.tv ];
    platforms = [ "i686-linux" ];
  };
}
