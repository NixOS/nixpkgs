{ lib, stdenv, fetchFromGitHub, nix, rustPlatform, CoreServices, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.40";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "mdBook";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-GGQK2Mf3EK1rwBMzQkAzWAaK6Fh0Qqqf8dtDjZPxOMA=";
  };

  cargoHash = "sha256-jriSQHn+Y+EWtwDJeMTAuCCHR7fEtWsErAxbG9a4pts=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mdbook \
      --bash <($out/bin/mdbook completions bash) \
      --fish <($out/bin/mdbook completions fish) \
      --zsh  <($out/bin/mdbook completions zsh )
  '';

  passthru = {
    tests = {
      inherit nix;
    };
  };

  meta = with lib; {
    description = "Create books from MarkDown";
    mainProgram = "mdbook";
    homepage = "https://github.com/rust-lang/mdBook";
    changelog = "https://github.com/rust-lang/mdBook/blob/v${version}/CHANGELOG.md";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ havvy Frostman matthiasbeyer ];
  };
}
