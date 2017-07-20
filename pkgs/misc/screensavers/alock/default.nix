{ stdenv, fetchgit, pkgconfig, autoreconfHook
, libX11, pam, libgcrypt, libXrender, imlib2 }:

stdenv.mkDerivation rec {
  date = "20160713";
  name = "alock-${date}";

  # Please consider https://github.com/Arkq/alock/issues/5
  # before upgrading past this revision.
  src = fetchgit {
    url = https://github.com/Arkq/alock;
    rev = "329ac152426639fe3c9e53debfc3f973c2988f50";
    sha256 = "078nf2afyqv7hpk5kw50i57anm7qqd8jnczygnwimh2q40bljm7x";
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

  meta = with stdenv.lib; {
    homepage = https://github.com/Arkq/alock;
    description = "Simple screen lock application for X server";
    longDescription = ''
      alock locks the X server until the user enters a password
      via the keyboard. If the authentification was successful
      the X server is unlocked and the user can continue to work.

      alock does not provide any fancy animations like xlock or
      xscreensaver and never will. It's just for locking the current
      X session.
    '';
    platforms = with platforms; allBut cygwin;
    maintainers = with maintainers; [ ftrvxmtrx chris-martin ];
  };
}
