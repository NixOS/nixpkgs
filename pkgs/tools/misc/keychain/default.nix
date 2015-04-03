{ stdenv, fetchFromGitHub, makeWrapper, coreutils, openssh, gnupg
, procps, gnugrep, gawk, findutils, gnused }:

stdenv.mkDerivation rec {
  name = "keychain-${version}";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "funtoo";
    repo = "keychain";
    rev = "1c8eaba53a7788d12d086b66ac3929810510f73a";
    sha256 = "0ajas58cv8mp5wb6hn1zhsqiwfxvx69p4f91a5j2as299rxgrxlp";
  };

  phases = [ "unpackPhase" "patchPhase" "buildPhase" ];

  buildInputs = [ makeWrapper ];

  patchPhase = "sed -i -e 's,version=.*,version=\"${version}\",g' keychain.sh";

  buildPhase = ''
    mkdir -p $out/bin
    cp keychain.sh $out/bin/keychain
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
    homepage = "http://www.funtoo.org/Keychain";
    license = stdenv.lib.licenses.gpl2;
  };
}
