{ stdenv, fetchFromGitHub, autoreconfHook, openssl, ppp, pkgconfig }:

with stdenv.lib;

let repo = "openfortivpn";
    version = "1.14.1";

in stdenv.mkDerivation {
  name = "${repo}-${version}";

  src = fetchFromGitHub {
    owner = "adrienverge";
    inherit repo;
    rev = "v${version}";
    sha256 = "1r9lp19fmqx9dw33j5967ydijbnacmr80mqnhbbxyqiw4k5c10ds";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = (if pkgs.stdenv.isDarwin then [ openssl ] else [ openssl ppp ]);

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

  configureFlags = (if pkgs.stdenv.isDarwin then [ "--with-pppd=/usr/sbin/pppd" ]
                    else [ "--with-pppd=${ppp}/bin/pppd" ] );

  enableParallelBuilding = true;

  meta = {
    description = "Client for PPP+SSL VPN tunnel services";
    homepage = "https://github.com/adrienverge/openfortivpn";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
