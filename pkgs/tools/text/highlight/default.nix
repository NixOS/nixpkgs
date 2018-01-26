{ stdenv, fetchFromGitHub, getopt, lua, boost, pkgconfig, gcc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "highlight-${version}";
  version = "3.41";

  src = fetchFromGitHub {
    owner = "andre-simon";
    repo = "highlight";
    rev = "${version}";
    sha256 = "163ghkyv3v6v200pskajlsz6sbq3hi31qx7abjcbwc0dajqfngvj";
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
    maintainers = with maintainers; [ ndowens willibutz ];
  };
}
