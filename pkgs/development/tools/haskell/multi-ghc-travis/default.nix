{ stdenv, ghc, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "multi-ghc-travis-${version}";
  version = "git-2017-05-24";

  buildInputs = [ ghc ];

  src = fetchFromGitHub {
    owner = "hvr";
    repo = "multi-ghc-travis";
    rev = "c1dcbcbcd3eadcc63adeac65d63497885b422a44";
    sha256 = "12xss8wgsqs2fghrfl4h6g5wli6wn274zmdsq5zdcib2m7da5yw2";
  };

  installPhase = ''
    mkdir -p $out/bin
    ghc -O --make make_travis_yml.hs -o $out/bin/make-travis-yml
    ghc -O --make make_travis_yml_2.hs -o $out/bin/make-travis-yml-2
  '';

  meta = with stdenv.lib; {
    description = "Generate .travis.yml for multiple ghc versions";
    homepage = "https://github.com/hvr/multi-ghc-travis";
    license = licenses.bsd3;
    platforms = ghc.meta.platforms;
    maintainers = with maintainers; [ jb55 ];
  };
}
