{ stdenv, fetchFromGitHub, makeWrapper, perlPackages }:

stdenv.mkDerivation rec {
  pname = "cloc";
  version = "1.84";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = version;
    sha256 = "14xikdwcr6pcnkk2i43zrsj88z8b3mrv0svbnbvxvarw1id83pnn";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */Unix)
  '';

  buildInputs = [ makeWrapper ] ++ (with perlPackages; [
    perl AlgorithmDiff ParallelForkManager RegexpCommon
  ]);

  makeFlags = [ "prefix=" "DESTDIR=$(out)" "INSTALL=install" ];

  postFixup = "wrapProgram $out/bin/cloc --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "A program that counts lines of source code";
    homepage = https://github.com/AlDanial/cloc;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ rycee ];
  };
}
