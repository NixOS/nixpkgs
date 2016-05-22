{ stdenv, fetchFromGitHub, makeWrapper, perl, AlgorithmDiff, RegexpCommon }:

stdenv.mkDerivation rec {
  name = "cloc-${version}";
  version = "1.66";

  src = fetchFromGitHub {
    owner = "AlDanial";
    repo = "cloc";
    rev = "v${version}";
    sha256 = "1xj6d8x8zwijym5wznm0k1478z7zx3bfjsx20r3aqb1vhkvcjsm9";
  };

  sourceRoot = "cloc-v${version}-src/Unix";

  buildInputs = [ makeWrapper perl AlgorithmDiff RegexpCommon ];

  makeFlags = [ "prefix=" "DESTDIR=$(out)" "INSTALL=install" ];

  postFixup = "wrapProgram $out/bin/cloc --prefix PERL5LIB : $PERL5LIB";

  meta = {
    description = "A program that counts lines of source code";
    homepage = https://github.com/AlDanial/cloc;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
