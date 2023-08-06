{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "languagetool-rust";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "jeertmans";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iiJSdr7TF1f8/Ve+OKbTDHYWdFkd2IEOzp7Lhlpwb50=";
  };

  cargoHash = "sha256-oCRlWYCTmJWTi6LCDEKimsLmqm3JTaQEsKJXrvQP/p8=";

  buildFeatures = [ "full" ];

  nativeBuildInputs = [ installShellFiles pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  checkFlags = [
    # requires network access
    "--skip=server::tests::test_server_check_data"
    "--skip=server::tests::test_server_check_text"
    "--skip=server::tests::test_server_languages"
    "--skip=server::tests::test_server_ping"
    "--skip=test_match_positions_1"
    "--skip=test_match_positions_2"
    "--skip=test_match_positions_3"
    "--skip=test_match_positions_4"
    "--skip=src/lib/lib.rs"
    "--skip=test_basic_check_data"
    "--skip=test_basic_check_file"
    "--skip=test_basic_check_files"
    "--skip=test_basic_check_piped"
    "--skip=test_basic_check_text"
    "--skip=test_check_with_dict"
    "--skip=test_check_with_dicts"
    "--skip=test_check_with_disabled_categories"
    "--skip=test_check_with_disabled_category"
    "--skip=test_check_with_disabled_rule"
    "--skip=test_check_with_disabled_rules"
    "--skip=test_check_with_enabled_categories"
    "--skip=test_check_with_enabled_category"
    "--skip=test_check_with_enabled_only_category"
    "--skip=test_check_with_enabled_only_rule"
    "--skip=test_check_with_enabled_only_without_enabled"
    "--skip=test_check_with_enabled_rule"
    "--skip=test_check_with_enabled_rules"
    "--skip=test_check_with_language"
    "--skip=test_check_with_picky_level"
    "--skip=test_check_with_preferred_variant"
    "--skip=test_check_with_preferred_variants"
    "--skip=test_check_with_unexisting_language"
    "--skip=test_check_with_username_and_key"
    "--skip=test_languages"
    "--skip=test_ping"
    "--skip=test_words"
    "--skip=test_words_add"
    "--skip=test_words_delete"
  ];

  postInstall = ''
    installShellCompletion --cmd ltrs \
      --bash <($out/bin/ltrs completions bash) \
      --fish <($out/bin/ltrs completions fish) \
      --zsh <($out/bin/ltrs completions zsh)
  '';

  meta = with lib; {
    description = "LanguageTool API in Rust";
    homepage = "https://github.com/jeertmans/languagetool-rust";
    license = licenses.mit;
    maintainers = with maintainers; [ name-snrl ];
    mainProgram = "ltrs";
  };
}
