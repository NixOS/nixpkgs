{ fetchFromGitHub
, rustPlatform
, pkg-config
, python3
, openssl
, cmake
, libmysqlclient
, makeBinaryWrapper
, lib
}:

let
  pyFxADeps = python3.withPackages (p: [
    p.setuptools # imports pkg_resources
    # remainder taken from requirements.txt
    p.pyfxa
    p.tokenlib
    p.cryptography
  ]);
in

rustPlatform.buildRustPackage rec {
  pname = "syncstorage-rs";
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = version;
    hash = "sha256-rayJvJ8+y1mw2BEKuaZqGnsIqtVKgBoFkINntRLtTLs=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    libmysqlclient
    openssl
  ];

  preFixup = ''
    wrapProgram $out/bin/syncstorage \
      --prefix PATH : ${lib.makeBinPath [ pyFxADeps ]}
  '';

  cargoSha256 = "sha256-FUWyR2mfXHyQ/WdyyV4/pIniBV9pr80WwpFA4c8D1UY=";

  buildFeatures = [ "grpcio/openssl" ];

  # almost all tests need a DB to test against
  doCheck = false;

  meta = {
    description = "Mozilla Sync Storage built with Rust";
    homepage = "https://github.com/mozilla-services/syncstorage-rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ pennae ];
  };
}
