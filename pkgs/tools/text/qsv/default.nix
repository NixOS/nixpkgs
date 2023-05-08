{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, sqlite
, zstd
, stdenv
, darwin
, python3
, file
}:

rustPlatform.buildRustPackage rec {
  pname = "qsv";
  version = "0.108.0";

  src = fetchFromGitHub {
    owner = "jqnatividad";
    repo = "qsv";
    rev = version;
    hash = "sha256-pN7DP7B4YdYLuQc1f+/zJXj+SRrLzBTx+4NmydCHugo=";
  };

  postPatch = ''
    rm .cargo/config.toml;
  '';

  cargoHash = "sha256-wT35Qhbm4r/rrsUAUNWmFjLjxiYL1zgIMq2dPNfxFb8=";

  buildInputs =
    [
      sqlite
      zstd
      file
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Security
    ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    python3
  ];

  buildNoDefaultFeatures = true;

  buildFeatures = [ "all_features" ];

  checkFlags = [
    "--skip cmd::validate::test_load_json_via_url"
    "--skip test_comments::envlist"
    "--skip test_fetch::fetch_custom_header"
    "--skip test_fetch::fetch_custom_user_agent"
    "--skip test_fetch::fetch_jql_multiple"
    "--skip test_fetch::fetch_jql_multiple_file"
    "--skip test_fetch::fetch_jql_single"
    "--skip test_fetch::fetch_jql_single_file"
    "--skip test_fetch::fetch_ratelimit"
    "--skip test_fetch::fetch_simple"
    "--skip test_fetch::fetch_simple_new_col"
    "--skip test_fetch::fetch_simple_url_template"
    "--skip test_fetch::fetchpost_custom_user_agent"
    "--skip test_fetch::fetchpost_literalurl_test"
    "--skip test_fetch::fetchpost_simple_test"
    "--skip test_luau::luau_register_lookup_table_ckan"
    "--skip test_luau::luau_register_lookup_table_on_dathere_url"
    "--skip test_luau::luau_register_lookup_table_on_url"
    "--skip test_sniff::sniff_url"
    "--skip test_sniff::sniff_url_snappy"
    "--skip test_to::to_parquet_dir"
    "--skip test_validate::validate_adur_public_toilets_dataset_with_json_schema_url"
  ];

  env = { ZSTD_SYS_USE_PKG_CONFIG = true; };

  meta = with lib; {
    description = "CSVs sliced, diced & analyzed";
    homepage = "https://github.com/jqnatividad/qsv";
    changelog = "https://github.com/jqnatividad/qsv/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
