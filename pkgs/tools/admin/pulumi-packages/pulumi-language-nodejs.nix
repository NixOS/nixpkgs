{ buildGoModule
, pulumi
, nodejs
}:
buildGoModule rec {
  inherit (pulumi) version src sdkVendorHash;

  pname = "pulumi-language-nodejs";

  sourceRoot = "${src.name}/sdk/nodejs/cmd/pulumi-language-nodejs";

  vendorHash = "sha256-gbZoDUJCKb5wcLhJ7DRSGHT3Q0xUlptUeS6Wen4dle0";

  postPatch = ''
    # Gives github.com/pulumi/pulumi/pkg/v3: is replaced in go.mod, but not marked as replaced in vendor/modules.txt etc
    substituteInPlace language_test.go \
      --replace "TestLanguage" \
                "SkipTestLanguage"
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
