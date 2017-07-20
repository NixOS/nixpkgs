{ stdenv, ghc, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "multi-ghc-travis-${version}";
  version = "git-2017-07-26";

  buildInputs = [ ghc ];

  src = fetchFromGitHub {
    owner = "hvr";
    repo = "multi-ghc-travis";
    rev = "800980d76f7a74f3cdfd76b3dff351d52d2c84ee";
    sha256 = "03y8b4iz5ly9vkjc551c1bxalg1vl4k2sic327s3vh00jmjgvhz6";
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
    maintainers = with maintainers; [ jb55 peti ];
  };
}
