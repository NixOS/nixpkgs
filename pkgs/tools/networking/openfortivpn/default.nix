{ stdenv, fetchFromGitHub, autoreconfHook, openssl, ppp }:

with stdenv.lib;

let repo = "openfortivpn";
    version = "1.0.1";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    owner = "adrienverge";
    inherit repo;
    rev = "v${version}";
    sha256 = "0kwl8hv3nydd34xp1489jpjdj4bmknfl9xrgynij0vf5qx29xv7m";
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
