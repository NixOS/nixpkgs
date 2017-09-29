{ stdenv, ghc, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "multi-ghc-travis-${version}";
  version = "20170728-git";

  buildInputs = [ ghc ];

  src = fetchFromGitHub {
    owner = "hvr";
    repo = "multi-ghc-travis";
    rev = "437739986fc81ca8c010e5d889348ba74171e680";
    sha256 = "05fbc7ab9c25k19xj0iax72gv62l89dw2m4bci7h76y9hcajs5v4";
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
