{ stdenv, fetchFromGitHub, makeWrapper, coreutils, openssh, gnupg
, perl, procps, gnugrep, gawk, findutils, gnused
, withProcps ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  name = "keychain-${version}";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "funtoo";
    repo = "keychain";
    rev = "1c8eaba53a7788d12d086b66ac3929810510f73a";
    sha256 = "0ajas58cv8mp5wb6hn1zhsqiwfxvx69p4f91a5j2as299rxgrxlp";
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
      ${if withProcps then ("--prefix PATH \":\" ${procps}/bin") else ""}
  '';

  meta = {
    description = "Keychain management tool";
    homepage = "http://www.funtoo.org/Keychain";
    license = stdenv.lib.licenses.gpl2;
    # other platforms are untested (AFAIK)
    platforms =
      with stdenv.lib;
      platforms.linux ++ platforms.darwin;
  };
}
