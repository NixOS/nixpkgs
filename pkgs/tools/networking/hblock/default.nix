{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, coreutils
, gawk
, curl
, gnugrep
}:

stdenv.mkDerivation rec {
  pname = "hblock";
<<<<<<< HEAD
  version = "3.4.2";
=======
  version = "3.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hectorm";
    repo = "hblock";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wO0xfD1bMRhoU7jorsIenlKJ87DzrtVH66OSZ4UT3MM=";
=======
    hash = "sha256-yOX/CsWs5HVH9s0KCzZm6PPqlDJHxz46jJB6KKC7Hsg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ coreutils curl gnugrep gawk ];
  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "prefix=$(out)"
  ];
  postInstall = ''
    wrapProgram "$out/bin/hblock" \
      --prefix PATH : ${lib.makeBinPath [ coreutils curl gnugrep gawk ]}
  '';

  meta = with lib; {
    description = "Improve your security and privacy by blocking ads, tracking and malware domains";
    homepage = "https://github.com/hectorm/hblock";
    license = licenses.mit;
    maintainers = with maintainers; [ alanpearce ];
<<<<<<< HEAD
    platforms = platforms.unix;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
