{ lib, stdenv, fetchFromGitHub, makeWrapper, perlPackages }:

stdenv.mkDerivation rec {
  pname = "cloc";
  version = "1.90";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = "v${version}";
    sha256 = "0ic9q6qqw5f1wafp9lpmhr0miasbdb9zr59c0jlymnzffdmnliyc";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */Unix)
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = (with perlPackages; [ perl AlgorithmDiff ParallelForkManager RegexpCommon ]);

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
