{ lib, stdenv
, fetchFromGitHub
, unstableGitUpdater
, makeWrapper
, openssl
, coreutils
, gnugrep }:

stdenv.mkDerivation {
  pname = "bash-supergenpass";
  version = "unstable-2024-03-24";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "lanzz";
    repo = "bash-supergenpass";
    rev = "03416ad4d753d825acd0443a01ac13d385d5e048";
    sha256 = "Q+xmT72UFCc71K87mAzpyTmEIXjR9SqX0xzmQfi5P9k=";
  };

  installPhase = ''
    install -m755 -D supergenpass.sh "$out/bin/supergenpass"
    wrapProgram "$out/bin/supergenpass" --prefix PATH : "${lib.makeBinPath [ openssl coreutils gnugrep ]}"
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/lanzz/bash-supergenpass.git";
  };

  meta = with lib; {
    description = "Bash shell-script implementation of SuperGenPass password generation";
    longDescription = ''
      Bash shell-script implementation of SuperGenPass password generation
      Usage: ./supergenpass.sh <domain> [ <length> ]

      Default <length> is 10, which is also the original SuperGenPass default length.

      The <domain> parameter is also optional, but it does not make much sense to omit it.

      supergenpass will ask for your master password interactively, and it will not be displayed on your terminal.
    '';
    homepage = "https://github.com/lanzz/bash-supergenpass";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "supergenpass";
    platforms = platforms.all;
  };
}
