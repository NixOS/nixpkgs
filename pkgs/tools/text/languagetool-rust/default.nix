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
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "jeertmans";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2RIfavAPxi8986f1hz7cnuIuKsPQ13PYy66FTnozIp0=";
  };

  cargoHash = "sha256-PE/q8laWos8K9b+sWg47iw/w0g4c3utkVd+KXXPJKhY=";

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
