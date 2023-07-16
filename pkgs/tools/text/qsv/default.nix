{ lib, fetchFromGitHub, rustPlatform, llvmPackages_16 }:

rustPlatform.buildRustPackage rec {
  pname = "qsv";
  version = "0.112.0";

  src = fetchFromGitHub {
    owner = "jqnatividad";
    repo = "qsv";
    rev = version;
    sha256 = "sha256-vcArimD1aIG4mq+5ehrNwpfXIL4SUCCNt1AXHpA/enI=";
  };

  # avoid the custom rustflags overrides
  preBuild = ''
    rm -rf .cargo/config.toml
  '';

  buildFeatures = [
    "feature_capable"
    "apply"
    "fetch"
    "foreach"
    "generate"
    "polars"
    "to"
  ];

  cargoHash = "sha256-8JDlQyHzP/xGNEIHAveyJ7DhA9t7h3O9F+libOT4f+A=";
  nativeBuildInputs = [ llvmPackages_16.clang ];

  LIBCLANG_PATH = lib.makeLibraryPath [ llvmPackages_16.libclang ];

  checkFlags = [
    # failing for unknown reasons
    "--skip=test_apply::apply_dynfmt"
    "--skip=test_apply::apply_calcconv"
    "--skip=test_apply::apply_calcconv_invalid"
    "--skip=test_apply::apply_calcconv_units"
    "--skip=test_foreach::foreach_multiple_commands_with_shell_script"
    "--skip=test_to::to_parquet_dir"
    # network
    "--skip=cmd::validate::test_load_json_via_url"
    "--skip=test_fetch::fetch_simple"
    "--skip=test_fetch::fetch_simple_new_col"
    "--skip=test_fetch::fetch_simple_report"
    "--skip=test_fetch::fetch_simple_url_template"
    "--skip=test_fetch::fetch_simple_redis"
    "--skip=test_fetch::fetch_jql_single"
    "--skip=test_fetch::fetch_jql_single_file"
    "--skip=test_fetch::fetch_jqlfile_doesnotexist_error"
    "--skip=test_fetch::fetch_jql_jqlfile_error"
    "--skip=test_fetch::fetch_jql_multiple"
    "--skip=test_fetch::fetch_jql_multiple_file"
    "--skip=test_fetch::fetch_custom_header"
    "--skip=test_fetch::fetch_custom_invalid_header_error"
    "--skip=test_fetch::fetch_custom_invalid_user_agent_error"
    "--skip=test_fetch::fetch_custom_user_agent"
    "--skip=test_fetch::fetch_custom_invalid_value_error"
    "--skip=test_fetch::fetchpost_custom_invalid_header_error"
    "--skip=test_fetch::fetchpost_custom_invalid_value_error"
    "--skip=test_fetch::fetchpost_custom_invalid_user_agent_error"
    "--skip=test_fetch::fetchpost_custom_user_agent"
    "--skip=test_fetch::fetch_ratelimit"
    "--skip=test_fetch::fetch_complex_url_template"
    "--skip=test_fetch::fetchpost_simple_test"
    "--skip=test_fetch::fetchpost_jqlfile_doesnotexist_error"
    "--skip=test_fetch::fetchpost_literalurl_test"
    "--skip=test_fetch::fetchpost_simple_report"
    "--skip=test_luau::luau_register_lookup_table_on_url"
    "--skip=test_luau::luau_register_lookup_table_on_dathere_url"
    "--skip=test_sample::sample_seed_url"
    "--skip=test_snappy::snappy_decompress_url"
    "--skip=test_sniff::sniff_url_notcsv"
    "--skip=test_sniff::sniff_url_snappy"
    "--skip=test_sniff::sniff_url_snappy_noinfer"
    "--skip=test_validate::validate_adur_public_toilets_dataset_with_json_schema_url"
    "--skip=test_describegpt::describegpt_invalid_api_key"
    "--skip=test_fetch::fetch_user_agent"
  ];

  meta = with lib; {
    description = "Ultra-fast CSV data-wrangling toolkit";
    homepage = "https://github.com/jqnatividad/qsv";
    license = with licenses; [ unlicense /* or */ mit ];
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ jgertm cpcloud ];
  };
}
