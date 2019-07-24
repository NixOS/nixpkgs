{ stdenv, fetchFromGitLab, getopt, lua, boost, pkgconfig, gcc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "highlight-${version}";
  version = "3.52";

  src = fetchFromGitLab {
    owner = "saalen";
    repo = "highlight";
    rev = "v${version}";
    sha256 = "0zhn1k70ck82ks7ckzsy1yiz686ym2ps7c28wjmkgxfpyjanilrq";
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
    homepage = http://www.andre-simon.de/doku/highlight/en/highlight.php;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ndowens willibutz ];
  };
}
