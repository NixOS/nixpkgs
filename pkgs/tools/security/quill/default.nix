{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  Security,
  libiconv,
  udev,
  pkg-config,
  protobuf,
  buildPackages,
}:

rustPlatform.buildRustPackage rec {
  pname = "quill";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dfinity";
    repo = "quill";
    rev = "v${version}";
    hash = "sha256-9M3xywc1Vx5jBFlOcQuYbvtUu8tJwOIxzMoomwANkm8=";
  };

  ic = fetchFromGitHub {
    owner = "dfinity";
    repo = "ic";
    rev = "2f9ae6bf5eafed03599fd29475100aca9f78ae81";
    hash = "sha256-QWJFsWZ9miWN4ql4xFXMQM1Y71nzgGCL57yAa0j7ch4=";
  };

  registry = "file://local-registry";

  preBuild = ''
    export REGISTRY_TRANSPORT_PROTO_INCLUDES=${ic}/rs/registry/transport/proto
    export IC_BASE_TYPES_PROTO_INCLUDES=${ic}/rs/types/base_types/proto
    export IC_PROTOBUF_PROTO_INCLUDES=${ic}/rs/protobuf/def
    export IC_NNS_COMMON_PROTO_INCLUDES=${ic}/rs/nns/common/proto
    export IC_ICRC1_ARCHIVE_WASM_PATH=${ic}/rs/rosetta-api/icrc1/wasm/ic-icrc1-archive.wasm.gz
    export LEDGER_ARCHIVE_NODE_CANISTER_WASM_PATH=${ic}/rs/rosetta-api/icp_ledger/wasm/ledger-archive-node-canister.wasm
    cp ${ic}/rs/rosetta-api/icp_ledger/ledger.did /build/quill-${version}-vendor/ledger.did
    export PROTOC=${buildPackages.protobuf}/bin/protoc
    export OPENSSL_DIR=${openssl.dev}
    export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-bY5JiyaXnVF/a1fbTP2wcvt4g7QNjf91j9I2WzqUrc8=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs =
    [
      openssl
      udev
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      libiconv
    ];

  meta = {
    homepage = "https://github.com/dfinity/quill";
    changelog = "https://github.com/dfinity/quill/releases/tag/v${version}";
    description = "Minimalistic ledger and governance toolkit for cold wallets on the Internet Computer";
    mainProgram = "quill";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ imalison ];
  };
}
