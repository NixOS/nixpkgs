{ lib
, stdenv
, buildGoModule
, darwin
, fetchFromGitHub
, restish
, testers
, xorg
}:

buildGoModule rec {
  pname = "restish";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "restish";
    rev = "refs/tags/v${version}";
    hash = "sha256-zAWlbfZywL8jepgmXBM5lacRv1N/+dBd+9vIavWAyNs=";
  };

  vendorHash = "sha256-sUBqeLhpWUu1NfAmFQCKFHm8DQaB8LYRrFexvuF8vC8=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.Kernel
  ] ++ lib.optionals stdenv.isLinux [
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests.version = testers.testVersion {
    package = restish;
  };

  meta = with lib; {
    description = "CLI tool for interacting with REST-ish HTTP APIs";
    homepage = "https://rest.sh/";
    changelog = "https://github.com/danielgtaylor/restish/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
