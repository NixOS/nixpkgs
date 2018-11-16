{ stdenv, fetchFromGitHub, makeWrapper, coreutils, openssh, gnupg
, perl, procps, gnugrep, gawk, findutils, gnused }:

stdenv.mkDerivation rec {
  name = "keychain-${version}";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "funtoo";
    repo = "keychain";
    rev = "${version}";
    sha256 = "1bkjlg0a2bbdjhwp37ci1rwikvrl4s3xlbf2jq2z4azc96dr83mj";
  };

  buildInputs = [ makeWrapper perl ];

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
    homepage = https://www.funtoo.org/Keychain;
    license = stdenv.lib.licenses.gpl2;
    # other platforms are untested (AFAIK)
    platforms =
      with stdenv.lib;
      platforms.linux ++ platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ sigma ];
  };
}
