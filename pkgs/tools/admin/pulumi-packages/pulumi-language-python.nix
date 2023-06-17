{ lib
, buildGoModule
, pulumi
, python3
}:
buildGoModule rec {
  inherit (pulumi) version src sdkVendorHash;

  pname = "pulumi-language-python";

  sourceRoot = "${src.name}/sdk";

  vendorHash = sdkVendorHash;

  postPatch = ''
    # Requires network
    substituteInPlace python/python_test.go \
      --replace "TestRunningPipInVirtualEnvironment" \
                "SkipTestRunningPipInVirtualEnvironment"

    substituteInPlace python/cmd/pulumi-language-python/main_test.go \
      --replace "TestDeterminePulumiPackages" \
                "SkipTestDeterminePulumiPackages"
  '';

  subPackages = [
    "python/cmd/pulumi-language-python"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  nativeCheckInputs = [
    python3
  ];

  postInstall = ''
    cp python/cmd/pulumi-language-python-exec    $out/bin
    cp python/dist/pulumi-resource-pulumi-python $out/bin
    cp python/dist/pulumi-analyzer-policy-python $out/bin
  '';
}
