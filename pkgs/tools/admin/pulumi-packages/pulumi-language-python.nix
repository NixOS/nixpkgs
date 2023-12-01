{ buildGoModule
, pulumi
, python3
}:
buildGoModule rec {
  inherit (pulumi) version src;

  pname = "pulumi-language-python";

  sourceRoot = "${src.name}/sdk/python/cmd/pulumi-language-python";

  vendorHash = "sha256-aLCgAcrgnNH/eYpGkr5Kj4xWjSgP76nz0YoV6998i9M=";

  postPatch = ''
    substituteInPlace main_test.go \
      --replace "TestDeterminePulumiPackages" \
                "SkipTestDeterminePulumiPackages"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  nativeCheckInputs = [
    python3
  ];

  postInstall = ''
    cp ../pulumi-language-python-exec           $out/bin
    cp ../../dist/pulumi-resource-pulumi-python $out/bin
    cp ../../dist/pulumi-analyzer-policy-python $out/bin
  '';
}
