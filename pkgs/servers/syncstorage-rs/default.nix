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
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = version;
    hash = "sha256-al3SgpJPg8dfdghV1dl00wShrKSJFegRVTilaOi0RHQ=";
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

  cargoSha256 = "sha256-+9Yi+oKctFiTR8cXN6ajtwKEC0kkOP3+kPfUPSYsx5A=";

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
