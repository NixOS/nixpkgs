{ lib
, buildGoModule
, go
, fetchFromGitHub
, makeWrapper
}:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7Kkx1XMWoi1P3UA2HlCsqVxr2d5jjs9JxMUvHWs1nlk=";
  };

  vendorHash = "sha256-YspUrnSS6d8Ta8dmUjx9A5D/V5Bqm08DQJrRBaIGyQg=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    go
  ];

  doCheck = false;

  subPackages = [
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
