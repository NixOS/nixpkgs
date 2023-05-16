<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, glib, hexdump, scowl }:
=======
{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, glib, util-linux, scowl }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "halfempty";
  version = "0.40";

  src = fetchFromGitHub {
    owner = "googleprojectzero";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YGq6fneAMo2jCpLPrjzRJ0eeOsStKaK5L+lwQfqcfpY=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pkg-config hexdump ];
  buildInputs = [ glib ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

=======
  nativeBuildInputs = [ pkg-config util-linux ];
  buildInputs = [ glib ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  enableParallelBuilding = true;

  patches = [
    (fetchpatch {
      name = "fix-bash-specific-syntax.patch";
      url = "https://github.com/googleprojectzero/halfempty/commit/ad15964d0fcaba12e5aca65c8935ebe3f37d7ea3.patch";
      sha256 = "sha256:0hgdci0wwi5wyw8i57w0545cxjmsmswm1y6g4vhykap0y40zizav";
    })
  ];

  postPatch = ''
    substituteInPlace test/Makefile \
      --replace '/usr/share/dict/words' '${scowl}/share/dict/words.txt'
  '';

  installPhase = ''
    install -vDt $out/bin halfempty
  '';

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Fast, parallel test case minimization tool";
    homepage = "https://github.com/googleprojectzero/halfempty/";
    maintainers = with lib.maintainers; [ fpletz ];
    license = with lib.licenses; [ asl20 ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
