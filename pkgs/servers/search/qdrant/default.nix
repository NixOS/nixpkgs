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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-mNprwomTVg/C75tPciQ4J8bb42ejpVKy/RSRcQySdvU=";
  };

  cargoHash = "sha256-HXKV5TaEXlrfbmoPgeS5cPKurmcwOm0ts1IVX7TvjGg=";

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
