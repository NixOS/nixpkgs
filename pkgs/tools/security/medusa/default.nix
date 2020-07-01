{ stdenv, fetchFromGitHub, pkg-config, freerdp, openssl, libssh2 }:

stdenv.mkDerivation rec {
  pname = "medusa-unstable";
  version = "2018-12-16";

  src = fetchFromGitHub {
    owner = "jmk-foofus";
    repo = "medusa";
    rev = "292193b3995444aede53ff873899640b08129fc7";
    sha256 = "0njlz4fqa0165wdmd5y8lfnafayf3c4la0r8pf3hixkdwsss1509";
  };

  outputs = [ "out" "man" ];

  configureFlags = [ "--enable-module-ssh=yes" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ freerdp openssl libssh2 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jmk-foofus/medusa";
    description = "A speedy, parallel, and modular, login brute-forcer";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ma27 ];
  };
}
