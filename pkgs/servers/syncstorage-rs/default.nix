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
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = version;
    hash = "sha256-zxpqQpzmPPU6V5QITK9SgAAI7l3/7+h0u3/bZgiU7y4=";
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

  cargoHash = "sha256-U0xHqOh0ii4PE9UYKo+diqSoZ1ZjzBmHILvAhHSZD0A=";

  buildFeatures = [ "grpcio/openssl" ];

  # almost all tests need a DB to test against
  doCheck = false;

  meta = {
    description = "Mozilla Sync Storage built with Rust";
    homepage = "https://github.com/mozilla-services/syncstorage-rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ pennae ];
    platforms = lib.platforms.linux;
  };
}
