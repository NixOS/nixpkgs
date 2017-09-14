{ stdenv, fetchurl, getopt, lua, boost, pkgconfig, gcc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "highlight-${version}";
  version = "3.39";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/${name}.tar.bz2";
    sha256 = "0z8gs69sqlyis4kvl8wwdgzywi199k73kkvn1mf9pf60npvcxwj4";
  };

  nativeBuildInputs = [ pkgconfig ] ++ optional stdenv.isDarwin  gcc ;

  buildInputs = [ getopt lua boost ];

  prePatch = stdenv.lib.optionalString stdenv.cc.isClang ''
    substituteInPlace src/makefile \
        --replace 'CXX=g++' 'CXX=clang++'
  '';

  preConfigure = ''
    makeFlags="PREFIX=$out conf_dir=$out/etc/highlight/"
  '';

  meta = with stdenv.lib; {
    description = "Source code highlighting tool";
    homepage = http://www.andre-simon.de/doku/highlight/en/highlight.php;
    platforms = platforms.unix;
    maintainers = [ maintainers.ndowens ];
  };
}
