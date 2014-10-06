{ stdenv, fetchgit, pkgconfig, autoconf, automake
, libX11, pam, libgcrypt, libXrender, imlib2 }:

stdenv.mkDerivation rec {
  date = "20140724";
  name = "alock-${date}";

  src = fetchgit {
    url = https://github.com/Arkq/alock;
    rev = "928ae09a85627570b7f6986fe161b71327405fc0";
    sha256 = "0z605w2cf0pc988qq931b2zis6dqavm0wcjfdmr6q4vamvinjfv0";
  };

  preConfigure = "autoreconf -fvi";
  configureFlags = [
    "--enable-pam"
    "--enable-hash"
    "--enable-xrender"
    "--enable-imlib2"
  ];
  buildInputs = [
    pkgconfig autoconf automake libX11
    pam libgcrypt libXrender imlib2
  ];

  meta = {
    homepage = https://github.com/Arkq/alock;
    description = "Simple screen lock application for X server";
    longDescription = ''
      alock locks the X server until the user enters a password
      via the keyboard. If the authentification was successful
      the X server is unlocked and the user can continue to work.

      alock does not provide any fancy animations like xlock or
      xscreensaver and never will. Its just for locking the current
      X session.
    '';
    platforms = with stdenv.lib.platforms; allBut cygwin;
    maintainers = [ stdenv.lib.maintainers.ftrvxmtrx ];
  };
}
