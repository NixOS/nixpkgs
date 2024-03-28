{ callPackage, buildGoModule, fetchFromGitHub, lib }:
let
  common = callPackage ./common.nix { };
  frontend = callPackage ./frontend.nix { };
in
buildGoModule {
  pname = common.name;

  inherit (common) src version vendorHash;

  preBuild = ''
    export HOME=$(mktemp -d)
    cp -R ${frontend}/ vue/dist
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/uptrace/uptrace/pkg/internal/version.Version=${common.version}"
  ];

  subPackages = [
    "cmd/uptrace"
  ];

  meta = common.meta // {
    description = "Open source APM: OpenTelemetry traces, metrics, and logs";
  };
}
