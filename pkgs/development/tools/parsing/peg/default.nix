{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "peg-0.1.18";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "114h1y4k8fwcq9m0hfk33dsp7ah8zxzjjzlk71x4iirzczfkn690";
  };

  preBuild="makeFlagsArray+=( PREFIX=$out )";

  meta = {
    homepage = http://piumarta.com/software/peg/;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
