{ stdenv, fetchFromGitHub, makeWrapper, perl
, AlgorithmDiff, ParallelForkManager, RegexpCommon
}:

stdenv.mkDerivation rec {
  name = "cloc-${version}";
  version = "1.76";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = "v${version}";
    sha256 = "03z4ar959ximsddd92zchi013lh82ganzisk309y3b09q10hl9k7";
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
