{ lib, stdenv, fetchFromGitHub, makeWrapper, perlPackages }:

stdenv.mkDerivation rec {
  pname = "cloc";
  version = "1.92";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = "v${version}";
    sha256 = if stdenv.isDarwin then
      "1hy1hskiw02b7xaxn2qz0v7znj14l49w1anx20z6rkcps7212l5l"
    else
      "sha256-tFARxNGXzWw+EN2qwBOhJEj7zwYfC9tVP0sAHqeGwcM=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */Unix)
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with perlPackages; [
    perl
    AlgorithmDiff
    ParallelForkManager
    RegexpCommon
  ];

  makeFlags = [ "prefix=" "DESTDIR=$(out)" "INSTALL=install" ];

  postFixup = "wrapProgram $out/bin/cloc --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "A program that counts lines of source code";
    homepage = "https://github.com/AlDanial/cloc";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ rycee ];
  };
}
