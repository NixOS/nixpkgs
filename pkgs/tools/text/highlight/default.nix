{ stdenv, fetchFromGitLab, getopt, lua, boost, pkgconfig, gcc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "highlight";
  version = "3.54";

  src = fetchFromGitLab {
    owner = "saalen";
    repo = "highlight";
    rev = "v${version}";
    sha256 = "1144qv3c02hd3qrnms9cxfprdmkvz06vy4zjq500wg4iz7r8654m";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ] ++ optional stdenv.isDarwin  gcc ;

  buildInputs = [ getopt lua boost ];

  prePatch = stdenv.lib.optionalString stdenv.cc.isClang ''
    substituteInPlace src/makefile \
        --replace 'CXX=g++' 'CXX=clang++'
  '';

  preConfigure = ''
    makeFlags="PREFIX=$out conf_dir=$out/etc/highlight/ CXX=$CXX AR=$AR"
  '';

  meta = with stdenv.lib; {
    description = "Source code highlighting tool";
    homepage = "http://www.andre-simon.de/doku/highlight/en/highlight.php";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ndowens willibutz ];
  };
}
