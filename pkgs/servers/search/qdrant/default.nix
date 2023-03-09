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
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "qdrant";
    repo = "qdrant";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-r47mfyuM3z3SKbUi1bz8cz7BS/X8/tsIOAMKavNTgN4=";
  };

  cargoHash = "sha256-EwB0Vz0NyKCek2rn1QHqk5zpReMjP0o46ajete9KmWk=";

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
