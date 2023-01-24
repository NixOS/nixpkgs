{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, editorconfig-checker }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = version;
    hash = "sha256-8qGRcyDayXx3OflhE9Kw2AXM702/2pYB3JgfpQ0UYR8=";
  };

  vendorHash = "sha256-S93ZvC92V9nrBicEv1yQ3DEuf1FmxtvFoKPR15e8VmA=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X main.version=${version}" ];

  postInstall = ''
    installManPage docs/editorconfig-checker.1
  '';

  passthru.tests.version = testers.testVersion {
    package = editorconfig-checker;
  };

  meta = with lib; {
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva zowoq ];
  };
}
