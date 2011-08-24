{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "keychain-2.7.1";

  src = fetchurl {
    url = mirror://gentoo/distfiles/keychain-2.7.1.tar.bz2;
    sha256 = "14ai6wjwnj09xnl81ar2dlr5kwb8y1k5ck6nc549shpng0zzw1qi";
  };

  phases = "unpackPhase buildPhase";

  buildPhase =
    ''
      mkdir -p $out/bin
      cp keychain $out/bin
    '';

  meta = { 
    description = "Keychain management tool";
    homepage = "http://www.gentoo.org/proj/en/keychain/";
    license = "GPL2";
  };
}
