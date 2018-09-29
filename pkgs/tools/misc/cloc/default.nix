{ stdenv, fetchFromGitHub, makeWrapper, perl
, AlgorithmDiff, ParallelForkManager, RegexpCommon
}:

stdenv.mkDerivation rec {
  name = "cloc-${version}";
  version = "1.78";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = version;
    sha256 = "030cnvl83hgynri3jimhhqp238375m1g6liqfiggl0habrnlbck2";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */Unix)
  '';

  buildInputs = [
    makeWrapper perl AlgorithmDiff ParallelForkManager RegexpCommon
  ];

  makeFlags = [ "prefix=" "DESTDIR=$(out)" "INSTALL=install" ];

  postFixup = "wrapProgram $out/bin/cloc --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "A program that counts lines of source code";
    homepage = https://github.com/AlDanial/cloc;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu rycee ];
  };
}
