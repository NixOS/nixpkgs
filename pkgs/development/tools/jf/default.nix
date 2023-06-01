{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "jf";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = "jf";
    rev = "v${version}";
    hash = "sha256-dZX8C/nJaKfgHsUAXR1DRZS+PWDZF+QDVpOSaOlwFp4=";
  };

  cargoHash = "sha256-H9UZCKy+0xL6J8f/6yCiM4X5TMOrN8UEEDwxqNR7xQY=";

  nativeBuildInputs = [ installShellFiles ];

  # skip auto manpage update
  buildNoDefaultFeatures = true;

  postInstall = ''
    installManPage assets/jf.1
  '';

  meta = with lib; {
    description = "A small utility to safely format and print JSON objects in the commandline";
    homepage = "https://github.com/sayanarijit/jf";
    license = licenses.mit;
    maintainers = [ maintainers.sayanarijit ];
  };
}
