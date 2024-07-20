{ lib
, stdenv
, fetchurl
, neon
, pkg-config
, zlib
, openssl
}:

stdenv.mkDerivation rec {
  pname = "cadaver";
  version = "0.24";

  src = fetchurl {
    url = "https://notroj.github.io/cadaver/cadaver-${version}.tar.gz";
    hash = "sha256-Rs/y8+vTLNMoNoEspHvMdTU/wr51fwk9qIwN2PEP1fY=";
  };

  configureFlags = [
    "--with-ssl"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    neon
    openssl
    zlib
  ];

  meta = with lib; {
    description = "Command-line WebDAV client";
    homepage = "https://notroj.github.io/cadaver/";
    changelog = "https://github.com/notroj/cadaver/blob/${version}/NEWS";
    maintainers = with maintainers; [ ianwookim ];
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ freebsd ++ openbsd;
    mainProgram = "cadaver";
  };
}
