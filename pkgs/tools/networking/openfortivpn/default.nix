{ stdenv, fetchFromGitHub, autoreconfHook, openssl, ppp }:

with stdenv.lib;

let repo = "openfortivpn";
    version = "1.3.0";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    owner = "adrienverge";
    inherit repo;
    rev = "v${version}";
    sha256 = "1jr2i0v82db7w9rdx5d64ph90b3hxi15yjy0abjg05wrpnbdyycp";
  };

  buildInputs = [ openssl ppp autoreconfHook ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

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
