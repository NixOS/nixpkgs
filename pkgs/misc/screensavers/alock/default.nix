{ stdenv, fetchgit, pkgconfig, autoreconfHook
, libX11, pam, libgcrypt, libXrender, imlib2 }:

stdenv.mkDerivation rec {
  date = "20170720";
  name = "alock-${date}";

  src = fetchgit {
    url = https://github.com/Arkq/alock;
    rev = "2035e1d4a2293432f5503e82d10f899232eb0f38";
    sha256 = "1by954fjn0ryqda89zlmq3gclakg3gz7zy1wjrbgw4lzsk538va6";
  };

  PAM_DEFAULT_SERVICE = "login";

  configureFlags = [
    "--enable-pam"
    "--enable-hash"
    "--enable-xrender"
    "--enable-imlib2"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoreconfHook libX11
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ ftrvxmtrx chris-martin ];
    license = licenses.mit;
  };
}
