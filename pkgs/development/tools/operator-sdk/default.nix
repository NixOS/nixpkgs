{ lib
, buildGoModule
, go
, fetchFromGitHub
, makeWrapper
}:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mDjBu25hOhm3FrUDsFq1rjBn58K91Bao8gqN2heZ9ps=";
  };

  vendorHash = "sha256-QfTWjSsWpbbGgKrv4U2E6jA6eAT4wnj0ixpUqDxtsY8=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    go
  ];

  doCheck = false;

  subPackages = [
    "cmd/ansible-operator"
    "cmd/helm-operator"
    "cmd/operator-sdk"
  ];

  # operator-sdk uses the go compiler at runtime
  allowGoReference = true;

  postFixup = ''
    wrapProgram $out/bin/operator-sdk --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = with lib; {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding";
    homepage = "https://github.com/operator-framework/operator-sdk";
    changelog = "https://github.com/operator-framework/operator-sdk/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnarg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
