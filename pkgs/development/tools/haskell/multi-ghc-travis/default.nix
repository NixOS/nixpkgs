{ stdenv, ghc, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "multi-ghc-travis-${version}";
  version = "git-2016-10-23";

  buildInputs = [ ghc ];

  src = fetchFromGitHub {
    owner = "hvr";
    repo = "multi-ghc-travis";
    rev = "03dd35f3801d6af4224906d45e982a748de9960e";
    sha256 = "1s08n8diis22cafych66zihdnd5q3dkv8m6i3a2s5g5f1phsk3mi";
  };

  patchPhase = ''
    substituteInPlace make_travis_yml.hs --replace "make_travis_yml.hs" "multi-ghc-travis"
  '';

  installPhase = ''
    mkdir -p $out/bin
    ghc -O --make make_travis_yml_2.hs -o $out/bin/multi-ghc-travis
  '';

  meta = with stdenv.lib; {
    description = "Generate .travis.yml for multiple ghc versions";
    homepage = "https://github.com/hvr/multi-ghc-travis";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ jb55 ];
  };
}
