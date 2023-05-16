{ lib, stdenv, fetchFromGitLab, autoreconfHook, pkg-config, nettle, gnutls
, libev, protobufc, guile, geoip, libseccomp, gperf, readline
, lz4, libgssglue, ronn, pam, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "ocserv";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "ocserv";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-mYf0cdWIxRSDGvszlFDex2SU6TtvodD1sXcUZOOcYd0=";
=======
    sha256 = "sha256-1grRt0F/myVzK+DMSeK5K0Ui8bJANEtE6/6IY+ZbPAw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook gperf pkg-config ronn ];
  buildInputs = [ nettle gnutls libev protobufc guile geoip libseccomp readline lz4 libgssglue pam libxcrypt ];

  meta = with lib; {
    homepage = "https://gitlab.com/openconnect/ocserv";
    license = licenses.gpl2Plus;
    description = "OpenConnect VPN server (ocserv), a server for the OpenConnect VPN client";
    maintainers = with maintainers; [ neverbehave ];
  };
}
