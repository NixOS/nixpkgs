{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook
, libX11, pam, libgcrypt, libXrender, imlib2 }:

stdenv.mkDerivation rec {
  pname = "alock";
  version = "unstable-2017-07-20";

  src = fetchFromGitHub {
    owner = "Arkq";
    repo = "alock";
    rev = "2035e1d4a2293432f5503e82d10f899232eb0f38";
    sha256 = "sha256-Rm00ytSfEv5Wljz4f/4bbyrK3sCV/oRUwz4DKx0pya8=";
  };

  PAM_DEFAULT_SERVICE = "login";

  configureFlags = [
    "--enable-pam"
    "--enable-hash"
    "--enable-xrender"
    "--enable-imlib2"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    autoreconfHook libX11
    pam libgcrypt libXrender imlib2
  ];

  meta = with lib; {
    homepage = "https://github.com/Arkq/alock";
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
