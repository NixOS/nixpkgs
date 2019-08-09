{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, nettle, gnutls
, libev, protobufc, guile, geoip, libseccomp, gperf, readline
, lz4, libgssglue, ronn, pam
}:

stdenv.mkDerivation rec {
  name = "ocserv-${version}";
  version = "0.12.4";

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "ocserv";
    rev = "ocserv_${stdenv.lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "0lybz93ah6n5b82ywshhmsmf65im8rk6gkxnzxfbxpqxra79j517";
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
