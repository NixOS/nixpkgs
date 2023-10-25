{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, shell2http
}:

buildGoModule rec {
  pname = "shell2http";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "msoap";
    repo = "shell2http";
    rev = "v${version}";
    hash = "sha256-FHLClAQYCR6DMzHyAo4gjN2nCmMptYevKJbhEZ8AJyE=";
  };

  vendorHash = "sha256-K/0ictKvX0sl/5hFDKjTkpGMze0x9fJA98RXNsep+DM=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  postInstall = ''
    installManPage shell2http.1
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = shell2http;
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Executing shell commands via HTTP server";
    homepage = "https://github.com/msoap/shell2http";
    changelog = "https://github.com/msoap/shell2http/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
