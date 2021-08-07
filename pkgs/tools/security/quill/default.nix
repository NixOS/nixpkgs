{ lib, stdenv, rustPlatform, fetchFromGitHub, openssl, Security, libiconv, pkg-config, protobuf, which, buildPackages }:

rustPlatform.buildRustPackage rec {
  pname = "quill";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dfinity";
    repo = "quill";
    rev = "v${version}";
    sha256 = "02ga2xkdxs36mfr4lv43cy6wkf27c28bdkzfkp3az5jvyk17mkfr";
  };

  ic = fetchFromGitHub {
    owner = "dfinity";
    repo = "ic";
    rev = "779549eccfcf61ac702dfc2ee6d76ffdc2db1f7f";
    sha256 = "1r31d5hab7k1n60a7y8fw79fjgfq04cgj9krwa6r9z4isi3919v6";
  };

  registry = "file://local-registry";

  preBuild = ''
    export REGISTRY_TRANSPORT_PROTO_INCLUDES=${ic}/rs/registry/transport/proto
    export IC_BASE_TYPES_PROTO_INCLUDES=${ic}/rs/types/base_types/proto
    export IC_PROTOBUF_PROTO_INCLUDES=${ic}/rs/protobuf/def
    export IC_NNS_COMMON_PROTO_INCLUDES=${ic}/rs/nns/common/proto
    export PROTOC=${buildPackages.protobuf}/bin/protoc
    export OPENSSL_DIR=${openssl.dev}
    export OPENSSL_LIB_DIR=${openssl.out}/lib
  '';

  cargoSha256 = "142pzhyi73ljlqas5vbhjhn4vmp9w9ps1mv8q7s3kzg0h7jcvm1k";

  nativeBuildInputs = [ pkg-config protobuf ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv ];

  meta = with lib; {
    homepage = "https://github.com/dfinity/quill";
    changelog = "https://github.com/dfinity/quill/releases/tag/v${version}";
    description = "Minimalistic ledger and governance toolkit for cold wallets on the Internet Computer.";
    license = licenses.asl20;
    maintainers = with maintainers; [ imalison ];
  };
}
