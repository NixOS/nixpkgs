{ lib
, buildGoModule
, pulumi
, nodejs
}:
buildGoModule rec {
  inherit (pulumi) version src sdkVendorHash;

  pname = "pulumi-language-nodejs";

  sourceRoot = "${src.name}/sdk";

  vendorHash = sdkVendorHash;

  subPackages = [
    "nodejs/cmd/pulumi-language-nodejs"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  nativeCheckInputs = [
    nodejs
  ];

  postInstall = ''
    cp nodejs/dist/pulumi-resource-pulumi-nodejs $out/bin
    cp nodejs/dist/pulumi-analyzer-policy $out/bin
  '';
}
