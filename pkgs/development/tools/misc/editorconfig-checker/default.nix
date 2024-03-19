{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, editorconfig-checker }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = "v${version}";
    hash = "sha256-T2+IqHDRGpmMFOL2V6y5BbF+rfaMsKaXvQ48CFpc52I=";
  };

  vendorHash = "sha256-vHIv3a//EfkYE/pHUXgFBgV3qvdkMx9Ka5xCk1J5Urw=";

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
    mainProgram = "editorconfig-checker";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva zowoq ];
  };
}
