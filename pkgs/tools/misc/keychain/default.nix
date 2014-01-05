{ stdenv, fetchurl, makeWrapper, coreutils, openssh, gnupg
, procps, gnugrep, gawk, findutils, gnused }:

stdenv.mkDerivation {
  name = "keychain-2.7.1";

  src = fetchurl {
    url = mirror://gentoo/distfiles/keychain-2.7.1.tar.bz2;
    sha256 = "14ai6wjwnj09xnl81ar2dlr5kwb8y1k5ck6nc549shpng0zzw1qi";
  };

  phases = [ "unpackPhase" "buildPhase" ];

  buildInputs = [ makeWrapper ];

  buildPhase = ''
    mkdir -p $out/bin
    cp keychain $out/bin
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
    homepage = "http://www.gentoo.org/proj/en/keychain/";
    license = "GPL2";
  };
}
