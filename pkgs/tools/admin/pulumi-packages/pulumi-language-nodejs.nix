{ buildGoModule
, pulumi
, nodejs
}:
buildGoModule rec {
  inherit (pulumi) version src;

  pname = "pulumi-language-nodejs";

  sourceRoot = "${src.name}/sdk/nodejs/cmd/pulumi-language-nodejs";

  vendorHash = "sha256-vs4M0JOVbNKLFNrlyeRp85EWCVGrPIhZs/KbwrQCqk4=";

  postPatch = ''
    # Gives github.com/pulumi/pulumi/pkg/v3: is replaced in go.mod, but not marked as replaced in vendor/modules.txt etc
    substituteInPlace language_test.go \
      --replace-quiet "TestLanguage" "SkipTestLanguage"
    substituteInPlace main_test.go \
      --replace-quiet "TestNonblockingStdout" "SkipTestNonblockingStdout"
    substituteInPlace main_test.go \
      --replace-quiet "TestGetProgramDependencies" "SkipTestGetProgramDependencies"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  nativeCheckInputs = [
    nodejs
  ];
}
