{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "ocb";
  # Also update `pkgs/tools/misc/opentelemetry-collector/releases.nix`
  # whenever that version changes.
  version = "0.116.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-collector";
    rev = "cmd/builder/v${version}";
    hash = "sha256-1wFLeRbiNytPEe262TEhBrAOLUkbsdLzKYngN2S3O4E=";
  };

  sourceRoot = "${src.name}/cmd/builder";
  vendorHash = "sha256-8g/92NOCj/mH1szrKR04R+Yy9GBYNnQFMi9KhqGKelU=";

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X go.opentelemetry.io/collector/cmd/builder/internal.version=${version}"
  ];

  # Some tests download new dependencies for a modified go.mod. Nix doesn't allow network access so skipping.
  checkFlags = [
    "-skip TestGenerateAndCompile|TestReplaceStatementsAreComplete|TestVersioning"
  ];

  # Rename to ocb (it's generated as "builder")
  postInstall = ''
    mv $out/bin/builder $out/bin/ocb
  '';

  meta = {
    description = "OpenTelemetry Collector";
    homepage = "https://github.com/open-telemetry/opentelemetry-collector.git";
    changelog = "https://github.com/open-telemetry/opentelemetry-collector/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davsanchez ];
    mainProgram = "ocb";
  };
}
