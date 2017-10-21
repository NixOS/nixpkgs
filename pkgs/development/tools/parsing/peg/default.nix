{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "peg-0.1.4";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "01agf4fbqv0r1xyqvj0va8kcrh3f2ka59f1aqvzfrabn7n5p8ik4";
  };

  preBuild="makeFlagsArray+=( PREFIX=$out )";

  preInstall=''
    mkdir -pv $out/bin $out/share/man/man1
    cp -pv *.1 $out/share/man/man1
  '';

  meta = {
    homepage = http://piumarta.com/software/peg/;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
