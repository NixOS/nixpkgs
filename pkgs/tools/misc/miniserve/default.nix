{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
, curl
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    hash = "sha256-f+k7ONX9bDrkyIhFxxaJvZYH2WBxYwCssbfM2fBPtRk=";
  };

  cargoHash = "sha256-Omxd0ZgvtEiciFnKWkYupyts2QT9LUTXxaTdfu0Jnx8=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeCheckInputs = [
    curl
  ];

  checkFlags = [
    "--skip=bind_ipv4_ipv6::case_2"
    "--skip=qrcode_hidden_in_tty_when_disabled"
    "--skip=qrcode_shown_in_tty_when_enabled"
    "--skip=show_root_readme_contents"
    "--skip=validate_printed_urls"
  ];

  postInstall = ''
    $out/bin/miniserve --print-manpage >miniserve.1
    installManPage miniserve.1

    installShellCompletion --cmd miniserve \
      --bash <($out/bin/miniserve --print-completions bash) \
      --fish <($out/bin/miniserve --print-completions fish) \
      --zsh <($out/bin/miniserve --print-completions zsh)
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "CLI tool to serve files and directories over HTTP";
    homepage = "https://github.com/svenstaro/miniserve";
    changelog = "https://github.com/svenstaro/miniserve/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "miniserve";
  };
}
