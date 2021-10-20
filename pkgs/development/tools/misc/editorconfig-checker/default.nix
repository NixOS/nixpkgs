{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = version;
    sha256 = "sha256-t1qvmTs6hOrAnq5hjU2Qjt33vdW9MuSOvWCCY82db+g=";
  };

  vendorSha256 = "sha256-Rs7u/ZepnMNg5EZ/HWqSdO428KOkxpSbo7rl0treqUY=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X main.version=${version}" ];

  postInstall = ''
    installManPage docs/editorconfig-checker.1
  '';

  meta = with lib; {
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva zowoq ];
  };
}
