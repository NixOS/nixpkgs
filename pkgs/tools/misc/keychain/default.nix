{ lib, stdenv, fetchFromGitHub, makeWrapper, coreutils, openssh, gnupg
, perl, procps, gnugrep, gawk, findutils, gnused }:

stdenv.mkDerivation rec {
  pname = "keychain";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "funtoo";
    repo = "keychain";
    rev = version;
    sha256 = "1bkjlg0a2bbdjhwp37ci1rwikvrl4s3xlbf2jq2z4azc96dr83mj";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    cp keychain $out/bin/keychain
    cp keychain.1 $out/share/man/man1
    wrapProgram $out/bin/keychain \
      --prefix PATH ":" "${coreutils}/bin" \
      --prefix PATH ":" "${openssh}/bin" \
      --prefix PATH ":" "${gnupg}/bin" \
      --prefix PATH ":" "${gnugrep}/bin" \
      --prefix PATH ":" "${gnused}/bin" \
      --prefix PATH ":" "${findutils}/bin" \
      --prefix PATH ":" "${gawk}/bin" \
      --prefix PATH ":" "${procps}/bin"
  '';

  meta = {
    description = "Keychain management tool";
    homepage = "https://www.funtoo.org/Keychain";
    license = lib.licenses.gpl2;
    # other platforms are untested (AFAIK)
    platforms =
      with lib;
      platforms.linux ++ platforms.darwin;
    maintainers = with lib.maintainers; [ sigma ];
    longDescription = ''
      Keychain helps you to manage SSH and GPG keys in a convenient and secure
      manner. It acts as a frontend to ssh-agent and ssh-add, but allows you
      to easily have one long running ssh-agent process per system, rather
      than the norm of one ssh-agent per login session.

      This dramatically reduces the number of times you need to enter your
      passphrase. With keychain, you only need to enter a passphrase once
      every time your local machine is rebooted. Keychain also makes it easy
      for remote cron jobs to securely "hook in" to a long-running ssh-agent
      process, allowing your scripts to take advantage of key-based logins.
    '';
  };
}
