{ lib
, buildGoModule
, pulumi
}:
buildGoModule rec {
  inherit (pulumi) version src;

  pname = "pulumi-language-nodejs";

  sourceRoot = "${src.name}/sdk";

  vendorHash = "sha256-gM3VpX6r/BScUyvk/XefAfbx0qYzdzSBGaWZN+89BS8=";

  subPackages = [
    "nodejs/cmd/pulumi-language-nodejs"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  postInstall = ''
    cp nodejs/dist/pulumi-resource-pulumi-nodejs $out/bin
    cp nodejs/dist/pulumi-analyzer-policy        $out/bin
  '';
}
