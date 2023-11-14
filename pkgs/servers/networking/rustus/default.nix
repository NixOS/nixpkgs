{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, nix-update-script
, pkg-config
, openssl
, Security
}:

let
  pname = "rustus";
  version = "0.7.6";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "s3rius";
    repo = pname;
    rev = version;
    hash = "sha256-osxdqwNUONCScFarpQV48C7CR1DVR/mCttaglqiAKPo=";
  };

  cargoHash = "sha256-M0mJ+9VznzHDmdKAsT3YamyG/P0JF8oPeVHaX44NWM4=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  passthru.updateScript = nix-update-script { };

  # too many tests fail for now
  # doCheck = false;
  # checkFlags = [
  #   # tries to make a network access
  #   "--skip=tests::curl_http_ockam"
  #   "--skip=medium_file_transfer"
  #   "--skip=medium_file_transfer_large_chunks"
  #   "--skip=medium_file_transfer_small_chunks"
  #   "--skip=tiny_file_transfer"
  #   "--skip=tiny_file_transfer_small_chunks"
  #   # tries to do IO
  #   "--skip=cli_state::tests::integration"
  #   "--skip=cli_state::tests::test_create_default_identity_state"
  #   "--skip=cli_state::tests::test_create_named_identity_state"
  #   "--skip=kafka::integration_test::test::producer__flow_with_mock_kafka__content_encryption_and_decryption"
  #   "--skip=kafka::portal_worker::test::kafka_portal_worker__metadata_exchange__response_changed"
  #   "--skip=full_flow"
  #   "--skip=run::parser::tests::detect_circular_dependency"
  #   "--skip=run::parser::tests::test_parse_config_with_depends_on"
  #   "--skip=util::tests::test_process_multi_addr"
  # ];


  meta = with lib; {
    description = "TUS protocol implementation in Rust.";
    homepage = "https://s3rius.github.io/rustus/";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.all;
  };
}
