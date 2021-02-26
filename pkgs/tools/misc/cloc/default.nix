{ lib, stdenv, fetchFromGitHub, makeWrapper, perlPackages }:

stdenv.mkDerivation rec {
  pname = "cloc";
  version = "1.88";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = version;
    sha256 = "1ixgswzbzv63bl50gb2kgaqr0jcicjz6w610hi9fal1i7744zraw";
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
