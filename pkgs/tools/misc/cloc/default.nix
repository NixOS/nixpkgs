{ stdenv, fetchFromGitHub, makeWrapper, perl, AlgorithmDiff, RegexpCommon }:

stdenv.mkDerivation rec {
  name = "cloc-${version}";
  version = "1.74";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = version;
    sha256 = "1ihma4f6f92jp1mvzr4rjrgyh9m5wzrlxngaxfn7g0a8r2kyi65b";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */Unix)
  '';

  buildInputs = [ makeWrapper perl AlgorithmDiff RegexpCommon ];

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
