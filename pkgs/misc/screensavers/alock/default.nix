{ stdenv, fetchgit, pkgconfig, autoconf, automake
, libX11, pam, libgcrypt, libXrender, imlib2 }:

stdenv.mkDerivation rec {
  date = "20141209";
  name = "alock-${date}";

  src = fetchgit {
    url = https://github.com/Arkq/alock;
    rev = "5ab7e6014faa1659c2d55bf9734bfa3ce7137443";
    sha256 = "07wf3vxh54ncxslp3zf8m7szpqbissxf8q9rs5zgvg333zdqd49s";
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
