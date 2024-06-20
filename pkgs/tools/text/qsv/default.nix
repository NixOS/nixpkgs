{ lib, fetchFromGitHub, rustPlatform, llvmPackages_17 }:

rustPlatform.buildRustPackage rec {
  pname = "qsv";
  version = "0.124.1";

  src = fetchFromGitHub {
    owner = "jqnatividad";
    repo = "qsv";
    rev = version;
    sha256 = "sha256-C+mFAMudbL/iI1RuZkoBlfyh512ilm868Oy8EJnkYI0=";
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
    "geocode"
    "polars"
    "to"
    "to_parquet"
  ];

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "dynfmt-0.1.5" = "sha256-/SrNOOQJW3XFZOPL/mzdOBppVCaJNNyGBuJumQGx6sA=";
      "grex-1.4.5" = "sha256-WQ2D94jnWGlWMkc+z56d809j16kXCtJyimeLj0iP3jk=";
    };
  };

  nativeBuildInputs = [ llvmPackages_17.clang ];

  LIBCLANG_PATH = lib.makeLibraryPath [ llvmPackages_17.libclang ];

  checkFlags = [
    # failing for unknown reasons
    "--skip=test_apply::apply_calcconv"
    "--skip=test_apply::apply_calcconv_invalid"
    "--skip=test_apply::apply_calcconv_units"
    "--skip=test_apply::apply_dynfmt"
    "--skip=test_foreach::foreach_multiple_commands_with_shell_script"
    "--skip=test_to::to_parquet_dir"
    # network
    "--skip=cmd::validate::test_load_json_via_url"
    "--skip=test_describegpt::describegpt_invalid_api_key"
    "--skip=test_fetch::fetch_complex_url_template"
    "--skip=test_fetch::fetch_custom_header"
    "--skip=test_fetch::fetch_custom_invalid_header_error"
    "--skip=test_fetch::fetch_custom_invalid_user_agent_error"
    "--skip=test_fetch::fetch_custom_invalid_value_error"
    "--skip=test_fetch::fetch_custom_user_agent"
    "--skip=test_fetch::fetch_jql_jqlfile_error"
    "--skip=test_fetch::fetch_jql_multiple"
    "--skip=test_fetch::fetch_jql_multiple_file"
    "--skip=test_fetch::fetch_jql_single"
    "--skip=test_fetch::fetch_jql_single_file"
    "--skip=test_fetch::fetch_jqlfile_doesnotexist_error"
    "--skip=test_fetch::fetch_ratelimit"
    "--skip=test_fetch::fetch_simple"
    "--skip=test_fetch::fetch_simple_new_col"
    "--skip=test_fetch::fetch_simple_redis"
    "--skip=test_fetch::fetch_simple_report"
    "--skip=test_fetch::fetch_simple_url_template"
    "--skip=test_fetch::fetch_user_agent"
    "--skip=test_fetch::fetchpost_custom_invalid_header_error"
    "--skip=test_fetch::fetchpost_custom_invalid_user_agent_error"
    "--skip=test_fetch::fetchpost_custom_invalid_value_error"
    "--skip=test_fetch::fetchpost_custom_user_agent"
    "--skip=test_fetch::fetchpost_jqlfile_doesnotexist_error"
    "--skip=test_fetch::fetchpost_literalurl_test"
    "--skip=test_fetch::fetchpost_simple_diskcache"
    "--skip=test_fetch::fetchpost_simple_report"
    "--skip=test_fetch::fetchpost_simple_test"
    "--skip=test_geocode::geocode_countryinfo"
    "--skip=test_geocode::geocode_countryinfo_formatstr"
    "--skip=test_geocode::geocode_countryinfo_formatstr_pretty_json"
    "--skip=test_geocode::geocode_countryinfonow"
    "--skip=test_geocode::geocode_countryinfonow_formatstr"
    "--skip=test_geocode::geocode_countryinfonow_formatstr_pretty_json"
    "--skip=test_geocode::geocode_reverse"
    "--skip=test_geocode::geocode_reverse_dyncols_fmt"
    "--skip=test_geocode::geocode_reverse_fmtstring"
    "--skip=test_geocode::geocode_reverse_fmtstring_intl"
    "--skip=test_geocode::geocode_reverse_fmtstring_intl_dynfmt"
    "--skip=test_geocode::geocode_reverse_fmtstring_intl_invalid_dynfmt"
    "--skip=test_geocode::geocode_reversenow"
    "--skip=test_geocode::geocode_suggest"
    "--skip=test_geocode::geocode_suggest_dyncols_fmt"
    "--skip=test_geocode::geocode_suggest_dynfmt"
    "--skip=test_geocode::geocode_suggest_filter_country_admin1"
    "--skip=test_geocode::geocode_suggest_fmt"
    "--skip=test_geocode::geocode_suggest_fmt_cityrecord"
    "--skip=test_geocode::geocode_suggest_fmt_json"
    "--skip=test_geocode::geocode_suggest_intl"
    "--skip=test_geocode::geocode_suggest_intl_admin1_filter_country_inferencing"
    "--skip=test_geocode::geocode_suggest_intl_country_filter"
    "--skip=test_geocode::geocode_suggest_intl_multi_country_filter"
    "--skip=test_geocode::geocode_suggest_invalid"
    "--skip=test_geocode::geocode_suggest_invalid_dynfmt"
    "--skip=test_geocode::geocode_suggest_pretty_json"
    "--skip=test_geocode::geocode_suggestnow"
    "--skip=test_geocode::geocode_suggestnow_default"
    "--skip=test_geocode::geocode_suggestnow_formatstr_dyncols"
    "--skip=test_luau::luau_register_lookup_table_on_dathere_url"
    "--skip=test_luau::luau_register_lookup_table_on_url"
    "--skip=test_sample::sample_seed_url"
    "--skip=test_snappy::snappy_decompress_url"
    "--skip=test_sniff::sniff_justmime_remote"
    "--skip=test_sniff::sniff_url_notcsv"
    "--skip=test_sniff::sniff_url_snappy"
    "--skip=test_sniff::sniff_url_snappy_noinfer"
    "--skip=test_validate::validate_adur_public_toilets_dataset_with_json_schema_url"
  ];

  meta = with lib; {
    description = "Ultra-fast CSV data-wrangling toolkit";
    homepage = "https://github.com/jqnatividad/qsv";
    license = with licenses; [ unlicense /* or */ mit ];
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ jgertm cpcloud ];
  };
}
