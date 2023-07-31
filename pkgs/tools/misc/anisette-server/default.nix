{ lib
, stdenv
, fetchurl
, openssl
, rustfmt
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "anisette-server";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/max-amb/anisette-server/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-2LuRRmjDFE8v9xDoo4clVKmcPS/jv4QQzkxtcgCQKvI=";
  };

  cargoSha256 = "sha256-oxFWy9ETHcrzS89aL26/GIJH7oeW3UKNrghueqL38k0=";

  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";

  nativeBuildInputs = [ rustfmt ];

  meta = with lib; {
    homepage = "https://github.com/max-amb/anisette-server";
    description = "anisette-server is a simple program to streamline the management of the docker crate nyamisty/alt_anisette_server";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ max-amb ];
  };
}
