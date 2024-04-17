{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, shell2http
}:

buildGoModule rec {
  pname = "shell2http";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "msoap";
    repo = "shell2http";
    rev = "v${version}";
    hash = "sha256-CU7ENLx5C1qCO1f9m0fl/AmUzmtmj6IjMlx9WNqAnS0=";
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
    mainProgram = "shell2http";
    homepage = "https://github.com/msoap/shell2http";
    changelog = "https://github.com/msoap/shell2http/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
