{ lib, stdenv, fetchFromGitLab, autoreconfHook, pkg-config, nettle, gnutls
, libev, protobufc, guile, geoip, libseccomp, gperf, readline
, lz4, libgssglue, ronn, pam
}:

stdenv.mkDerivation rec {
  pname = "ocserv";
  version = "1.1.4";

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "ocserv";
    rev = version;
    sha256 = "sha256-0/BDB7vuLRnp/xhsRTdd0z3FrFZcXwohKCDvQNkbVaI=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ nettle gnutls libev protobufc guile geoip libseccomp gperf readline lz4 libgssglue ronn pam ];

  meta = with lib; {
    homepage = "https://gitlab.com/openconnect/ocserv";
    license = licenses.gpl2;
    description = "This program is openconnect VPN server (ocserv), a server for the openconnect VPN client";
    maintainers = with maintainers; [ neverbehave ];
  };
}
