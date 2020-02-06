{ stdenv, fetchFromGitLab, autoreconfHook, pkgconfig, nettle, gnutls
, libev, protobufc, guile, geoip, libseccomp, gperf, readline
, lz4, libgssglue, ronn, pam
}:

stdenv.mkDerivation rec {
  pname = "ocserv";
  version = "0.12.6";

  src = fetchFromGitLab {
    owner = "openconnect";
    repo = "ocserv";
    rev = "ocserv_${stdenv.lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "0k7sx9sg8akxwfdl51cvdqkdrx9qganqddgri2yhcgznc3f3pz5b";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ nettle gnutls libev protobufc guile geoip libseccomp gperf readline lz4 libgssglue ronn pam ];

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/openconnect/ocserv;
    license = licenses.gpl2;
    description = "This program is openconnect VPN server (ocserv), a server for the openconnect VPN client.";
    maintainers = with maintainers; [ ];
  };
}
