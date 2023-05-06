{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
, stdenv
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "qdrant";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Kjao5TjVT8QVV2tKt7TTt9cYmYXRl/oPLi8UK1tc/nA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "quantization-0.1.0" = "sha256-4TY08ScRbL4zVG428BTZu42ocAsPk/8wM+zzI8EFSrs=";
      "wal-0.1.2" = "sha256-EfCvwgHMfyiId8VjV+yFyNqoIv6fxF8UFcw1s46hF5k=";
    };
  };

  prePatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace .cargo/config.toml \
      --replace "[target.aarch64-unknown-linux-gnu]" "" \
      --replace "linker = \"aarch64-linux-gnu-gcc\"" ""
  '';

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  nativeBuildInputs = [ protobuf rustPlatform.bindgenHook pkg-config ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-faligned-allocation";

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
