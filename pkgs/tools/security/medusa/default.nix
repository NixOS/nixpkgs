{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, freerdp, openssl, libssh2 }:

stdenv.mkDerivation rec {
  pname = "medusa-unstable";
  version = "2018-12-16";

  src = fetchFromGitHub {
    owner = "jmk-foofus";
    repo = "medusa";
    rev = "292193b3995444aede53ff873899640b08129fc7";
    sha256 = "0njlz4fqa0165wdmd5y8lfnafayf3c4la0r8pf3hixkdwsss1509";
  };

  patches = [
    # Pull upstream fix for -fno-common tollchains like gcc-10:
    #  https://github.com/jmk-foofus/medusa/pull/36
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/jmk-foofus/medusa/commit/a667656ad085b3eb95309932666c250d97a92767.patch";
      sha256 = "01marqqhjd3qwar3ymp50y1h2im5ilgpaxk7wrc2kcxgmzvbdfxc";
    })
  ];

  outputs = [ "out" "man" ];

  configureFlags = [ "--enable-module-ssh=yes" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ freerdp openssl libssh2 ];

  meta = with lib; {
    homepage = "https://github.com/jmk-foofus/medusa";
    description = "Speedy, parallel, and modular, login brute-forcer";
    mainProgram = "medusa";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
