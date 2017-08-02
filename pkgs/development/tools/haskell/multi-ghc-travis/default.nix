{ stdenv, ghc, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "multi-ghc-travis-${version}";
  version = "git-2017-07-27";

  buildInputs = [ ghc ];

  src = fetchFromGitHub {
    owner = "hvr";
    repo = "multi-ghc-travis";
    rev = "f21804164cf646d682d7da668a625cdbd8baf05a";
    sha256 = "07l3qzlc2hl7g5wbgqh8ld8ynl004i6m7p903667gbhs7sw03nbl";
  };

  installPhase = ''
    mkdir -p $out/bin
    ghc -O --make make_travis_yml.hs -o $out/bin/make-travis-yml
    ghc -O --make make_travis_yml_2.hs -o $out/bin/make-travis-yml-2
  '';

  meta = with stdenv.lib; {
    description = "Generate .travis.yml for multiple ghc versions";
    homepage = https://github.com/hvr/multi-ghc-travis;
    license = licenses.bsd3;
    platforms = ghc.meta.platforms;
    maintainers = with maintainers; [ jb55 peti ];
  };
}
