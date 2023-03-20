{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2J9Xx2DlMTh8o7T/tNZm3QK69gkQo3lj8kBVHhESMTs=";
  };

  cargoSha256 = "sha256-2gZGEpYNR7/mOleAfhDf3hZq1vRKlfWwT25DFIi5w8o=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completions/argc.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "A tool to handle sh/bash cli parameters";
    homepage = "https://github.com/sigoden/argc";
    changelog = "https://github.com/sigoden/argc/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
