{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libevent, file, qrencode, miniupnpc }:

stdenv.mkDerivation rec {
  name = "pshs-${version}";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "mgorny";
    repo = "pshs";
    rev = "v${version}";
    sha256 = "04l03myh99npl78y8nss053gnc7k8q60vdbdpml19sshmwaw3fgi";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libevent file qrencode miniupnpc ];

  # SSL requires libevent at 2.1 with ssl support
  configureFlags = [ "--disable-ssl" ];

  meta = {
    description = "Pretty small HTTP server - a command-line tool to share files";
    homepage = https://github.com/mgorny/pshs;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
