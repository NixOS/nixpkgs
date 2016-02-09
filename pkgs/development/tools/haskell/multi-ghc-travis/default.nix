{ stdenv, ghc, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "multi-ghc-travis-${version}";
  version = "git-2015-11-04";

  buildInputs = [ ghc ];

  src = fetchFromGitHub {
    owner = "hvr";
    repo = "multi-ghc-travis";
    rev = "4c288937ff8b80f6f1532609f9920912856dc3ee";
    sha256 = "0978k81by403in7iq7ia4hsfwlvaalnjqyh3ihwyw8822a5gm8y9";
  };

  patchPhase = ''
    substituteInPlace make_travis_yml.hs --replace "make_travis_yml.hs" "multi-ghc-travis"
  '';

  installPhase = ''
    mkdir -p $out/bin
    ghc -O --make make_travis_yml.hs -o $out/bin/multi-ghc-travis
  '';

  meta = with stdenv.lib; {
    description = "Generate .travis.yml for multiple ghc versions";
    homepage = "https://github.com/hvr/multi-ghc-travis";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ jb55 ];
  };
}
