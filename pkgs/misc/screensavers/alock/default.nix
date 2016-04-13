{ stdenv, fetchgit, pkgconfig, autoreconfHook
, libX11, pam, libgcrypt, libXrender, imlib2 }:

stdenv.mkDerivation rec {
  date = "20150418";
  name = "alock-${date}";

  src = fetchgit {
    url = https://github.com/Arkq/alock;
    rev = "69b547602d965733d415f877eb59d05966bd158d";
    sha256 = "c1f00bf90c966b2b76e00061cc4b54a3c0bc6547e788731ab694b43f55a216ab";
  };

  configureFlags = [
    "--enable-pam"
    "--enable-hash"
    "--enable-xrender"
    "--enable-imlib2"
  ];
  buildInputs = [
    pkgconfig autoreconfHook libX11
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
