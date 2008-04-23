args:
args.stdenv.mkDerivation {
  name = "keychain-2.6.6";

  src = args.fetchurl {
    url = http://gentoo.chem.wisc.edu/gentoo/distfiles/keychain-2.6.6.tar.bz2;
    sha256 = "10v0hzkgrb5cazm1gk0g4ncwp8sqvfk7xfyx59cjd69kzhbbn6ic";
  };

  phases = "unpackPhase buildPhase";

  buildPhase ="
    mkdir -p \$out/bin
    cp keychain \$out/bin
  ";

  buildInputs =(with args; []);

  meta = { 
      description = "tool starting ssh and gpg management tool";
      homepage = "http://www.gentoo.org/proj/en/keychain/";
      license = "GPL2";
  };
}
