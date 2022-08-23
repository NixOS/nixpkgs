{ lib, stdenv
, fetchFromGitHub
, unstableGitUpdater
, makeWrapper
, openssl
, coreutils
, gnugrep }:

stdenv.mkDerivation {
  pname = "bash-supergenpass";
  version = "unstable-2020-02-03";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "lanzz";
    repo = "bash-supergenpass";
    rev = "e5d96599b65d65a37148996f00f9d057e522e4d8";
    sha256 = "1d8csp94l2p5y5ln53aza5qf246rwmd10043x0x1yrswqrrya40f";
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
