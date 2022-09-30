{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Y6qXxnjep9AF3aAW6EZNx4dghMH3BSw8ExpNhTVH1QI=";
  };

  cargoSha256 = "sha256-Wr+sUtxxdmY6l+sMAcQGR3Zmqvj8qybC74o9ipkwTMk=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completions/argc.{bash,zsh}
  '';

  meta = with lib; {
    description = "A tool to handle sh/bash cli parameters";
    homepage = "https://github.com/sigoden/argc";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
