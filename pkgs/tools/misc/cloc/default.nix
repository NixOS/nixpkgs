{ stdenv, fetchFromGitHub, makeWrapper, perlPackages }:

stdenv.mkDerivation rec {
  name = "cloc-${version}";
  version = "1.82";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = version;
    sha256 = "0fsz07z0slfg58512fmnlj8pnxkc360bgf7fclg60v9clvcjbjsw";
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
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu rycee ];
  };
}
