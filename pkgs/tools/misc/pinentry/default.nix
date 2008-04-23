args:
args.stdenv.mkDerivation {
  name = "pinentry-0.7.2";

  src = args.fetchurl {
    url = http://gentoo.chem.wisc.edu/gentoo/distfiles/pinentry-0.7.2.tar.gz;
    sha256 = "0s6n5n4bxg95rmwa3mw3r49dabf8yh6fkpfi8mbl7i85dgpibnzv";
  };

  buildInputs =(with args; [glib pkgconfig x11 gtk]);

  meta = { 
      description = "input interface for passwords needed by  gnupg";
      homepage = "don't know, gentoo lists http://www.gnupg.org/aegypten/";
      license = "GPL2";
  };
}
