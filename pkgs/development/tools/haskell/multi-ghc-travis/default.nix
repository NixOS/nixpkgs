{ stdenv, ghc, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "multi-ghc-travis-${version}";
  version = "git-2017-05-18";

  buildInputs = [ ghc ];

  src = fetchFromGitHub {
    owner = "hvr";
    repo = "multi-ghc-travis";
    rev = "3e1b3847583020f0e83c97fcf4bcfb7c90b78259";
    sha256 = "0hnwp9gsv2rnkxqiw4cg1vdi7wccajx0i9ryhw4lfr8nhkizbsww";
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
    platforms = platforms.all;
    maintainers = with maintainers; [ jb55 ];
  };
}
