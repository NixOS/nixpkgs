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
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-LCMbhFoxi/fYaivW5gNyDhfytW/avhrrd29fXobSxJU=";
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
    wrapProgram $out/bin/syncserver \
      --prefix PATH : ${lib.makeBinPath [ pyFxADeps ]}
  '';

  cargoHash = "sha256-OPPU1SKR+zNmJ1NNAv4B3C9FOF/Ddg53genUkVwNgSs=";

  buildFeatures = [ "grpcio/openssl" ];

  # almost all tests need a DB to test against
  doCheck = false;

  meta = {
    description = "Mozilla Sync Storage built with Rust";
    homepage = "https://github.com/mozilla-services/syncstorage-rs";
    changelog = "https://github.com/mozilla-services/syncstorage-rs/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ pennae ];
    platforms = lib.platforms.linux;
  };
}
