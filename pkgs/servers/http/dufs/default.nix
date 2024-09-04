{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dufs";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "dufs";
    rev = "v${version}";
    hash = "sha256-Ab/f6n2n24mLsWS4WF6jOBt9m7dyeSP0ftYixKANsjY=";
  };

  cargoHash = "sha256-CNHDZHyg4jrEl3hmdQ7ITCtg9iTmB2RwDAzqSirOCO4=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # FIXME: checkPhase on darwin will leave some zombie spawn processes
  # see https://github.com/NixOS/nixpkgs/issues/205620
  doCheck = !stdenv.isDarwin;
  checkFlags = [
    # tests depend on network interface, may fail with virtual IPs.
    "--skip=validate_printed_urls"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dufs \
      --bash <($out/bin/dufs --completions bash) \
      --fish <($out/bin/dufs --completions fish) \
      --zsh <($out/bin/dufs --completions zsh)
  '';

  meta = with lib; {
    description = "File server that supports static serving, uploading, searching, accessing control, webdav";
    mainProgram = "dufs";
    homepage = "https://github.com/sigoden/dufs";
    changelog = "https://github.com/sigoden/dufs/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda holymonson ];
  };
}
