{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, nettle, gnutls
, libev, protobufc, guile, geoip, libseccomp, gperf, readline
, lz4, libgssglue, ronn, coreutils, pam
}:

stdenv.mkDerivation rec {
  name = "ocserv-${version}";
  version = "0.12.3";

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "ocserv";
    rev = "ocserv_${stdenv.lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "072256099l1c6p7dvvzp0gyafh1zvmmgmnpy0fcmv9sy80qg3p44";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ nettle gnutls libev protobufc guile geoip libseccomp gperf readline lz4 libgssglue ronn pam ];

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/openconnect/ocserv;
    license = licenses.gpl2;
    description = "This program is openconnect VPN server (ocserv), a server for the openconnect VPN client.";
    maintainers = with maintainers; [ ma27 ];
  };
}
