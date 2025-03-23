{
  lib,
  buildGoModule,
  pulumi,
  bash,
  nodejs,
  python3,
}:
buildGoModule rec {
  pname = "pulumi-language-nodejs";
  inherit (pulumi) version src;

  sourceRoot = "${src.name}/sdk/nodejs/cmd/pulumi-language-nodejs";

  vendorHash = "sha256-vmFoMxWK5sj3vsBVFAji0Pz2wtf1H3MJhbrkHshDOno=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestLanguage"
        "TestGetProgramDependencies"
      ]
    }$"
  ];

  nativeCheckInputs = [
    python3 # for TestNonblockingStdout
    nodejs
  ];

  # For patchShebangsAuto (see scripts copied in postInstall).
  buildInputs = [
    bash
  ];

  postInstall = ''
    cp -t "$out/bin" \
      ../../dist/pulumi-resource-pulumi-nodejs \
      ../../dist/pulumi-analyzer-policy
  '';

  meta = {
    homepage = "https://www.pulumi.com/docs/iac/languages-sdks/javascript/";
    description = "Language host for Pulumi programs written in TypeScript & JavaScript (Node.js)";
    license = lib.licenses.asl20;
    mainProgram = "pulumi-language-nodejs";
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
