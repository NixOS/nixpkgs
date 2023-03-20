{ lib
, buildGoModule
, pulumi
}:
buildGoModule rec {
  pname = "pulumi-language-go";
  inherit (pulumi) version src;

  sourceRoot = "${src.name}/sdk";

  vendorHash = pulumi.sdkVendorHash;

  subPackages = [
    "go/pulumi-language-go"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];
  meta = with lib; {
    description = "Golang language host plugin for Pulumi";
    homepage = "https://github.com/pulumi/pulumi/tree/master/sdk/go";
    license = licenses.asl20;
  };
}
