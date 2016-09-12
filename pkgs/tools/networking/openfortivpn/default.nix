{ stdenv, fetchFromGitHub, autoreconfHook, openssl, ppp }:

with stdenv.lib;

let repo = "openfortivpn";
    version = "1.1.4";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    owner = "adrienverge";
    inherit repo;
    rev = "v${version}";
    sha256 = "08ycz053wa29ckgr93132hr3vrd84r3bks9q807qanri0n35y256";
  };

  buildInputs = [ openssl ppp autoreconfHook ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    substituteInPlace src/tunnel.c --replace "/usr/sbin/pppd" "${ppp}/bin/pppd"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Client for PPP+SSL VPN tunnel services";
    homepage = https://github.com/adrienverge/openfortivpn;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.linux;
  };
}
