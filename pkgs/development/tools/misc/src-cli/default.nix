{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
, xorg
, darwin
, testers
, src-cli
}:

buildGoModule rec {
  pname = "src-cli";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-eN+MByapusaznL3BR1WOWJ3tMtxJ4yrxrcNCHOgoL0k=";
  };

  vendorHash = "sha256-+7/bY0qrRRZ0GNkIcuqOi4MA8wE75/HllRI6e/IQgy4=";

  subPackages = [
    "cmd/src"
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    xorg.libX11
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sourcegraph/src-cli/internal/version.BuildTag=${version}"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    version = testers.testVersion {
      package = src-cli;
      command = "src version || true";
    };
  };

  meta = with lib; {
    description = "Sourcegraph CLI";
    homepage = "https://github.com/sourcegraph/src-cli";
    changelog = "https://github.com/sourcegraph/src-cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "src";
  };
}
