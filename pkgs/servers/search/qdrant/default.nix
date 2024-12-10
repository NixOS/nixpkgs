{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  stdenv,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
  nix-update-script,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "qdrant";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-SirqQW/OxFvsyra80znSDakHwFjHk2YkpAaNwXnbK60=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "quantization-0.1.0" = "sha256-BofK1X06efESoxVJmlCY5D3toFmo2ZkKNz11ot2imIs=";
      "tonic-0.9.2" = "sha256-ZlcDUZy/FhxcgZE7DtYhAubOq8DMSO17T+TCmXar1jE=";
      "wal-0.1.2" = "sha256-YjOXYg8dnYsb+Zl6xUkAccjZZn3tyf3fR/kWTfUjlgg=";
    };
  };

  buildInputs =
    [
      openssl
      rust-jemalloc-sys
    ]
    ++ lib.optionals stdenv.isDarwin [
      Security
      SystemConfiguration
    ];

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
    pkg-config
  ];

  env =
    {
      # Needed to get openssl-sys to use pkg-config.
      OPENSSL_NO_VENDOR = 1;
    }
    // lib.optionalAttrs stdenv.cc.isClang {
      NIX_CFLAGS_COMPILE = "-faligned-allocation";
    };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Vector Search Engine for the next generation of AI applications";
    longDescription = ''
      Expects a config file at config/config.yaml with content similar to
      https://github.com/qdrant/qdrant/blob/master/config/config.yaml
    '';
    homepage = "https://github.com/qdrant/qdrant";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
