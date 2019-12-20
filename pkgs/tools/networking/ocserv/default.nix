{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, nettle, gnutls
, libev, protobufc, guile, geoip, libseccomp, gperf, readline
, lz4, libgssglue, ronn, pam
}:

stdenv.mkDerivation rec {
  pname = "ocserv";
  version = "0.12.5";

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "ocserv";
    rev = "ocserv_${stdenv.lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "01md7r7myaxp614bm2bmbpraxjjjhs0zr5h6k3az3y3ix0r7zi69";
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
