{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, editorconfig-checker }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = version;
    hash = "sha256-ktZeBj5feJMf4XR4hybKdNrNCIrQD6KPetZffAZjwqI=";
  };

  vendorHash = "sha256-dhvRZ+AYSmSzHsf3yOYBSvZbw7dfwQiILu+VSUX8N3s=";

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
    changelog = "https://github.com/editorconfig-checker/editorconfig-checker/releases/tag/${src.rev}";
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva zowoq ];
  };
}
