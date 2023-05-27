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
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "jeertmans";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tgx1LcVAlBcgYAdtn4n5TiLzinmOImLoatGowUFHpUM=";
  };

  cargoHash = "sha256-8Q+Li4wLkS9/HlSdtfOFnojtUBojO3oUpNHkyOu5clA=";

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
