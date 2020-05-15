{ stdenv, fetchFromGitHub, autoreconfHook, openssl, ppp, pkgconfig }:

with stdenv.lib;

let repo = "openfortivpn";
    version = "1.13.3";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    owner = "adrienverge";
    inherit repo;
    rev = "v${version}";
    sha256 = "1y3b3zwzig520nyky7xnr0l0zf68i4w698bysyngpkada14d8dv3";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ openssl ppp ];

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

  configureFlags = [ "--with-pppd=${ppp}/bin/pppd" ];

  enableParallelBuilding = true;

  meta = {
    description = "Client for PPP+SSL VPN tunnel services";
    homepage = "https://github.com/adrienverge/openfortivpn";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.linux;
  };
}
