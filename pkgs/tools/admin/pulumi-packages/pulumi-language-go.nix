{ lib
, buildGoModule
, pulumi
}:
buildGoModule rec {
  pname = "pulumi-language-go";
  inherit (pulumi) version src;

  sourceRoot = "${src.name}/sdk/go/pulumi-language-go";

  vendorHash = "sha256-mBK9VEatuxeoZtXXOKdwj7wtZ/lo4Bi2h7N00zK6Hpw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  # go: inconsistent vendoring in ...
  doCheck = false;

  meta = with lib; {
    description = "Golang language host plugin for Pulumi";
    homepage = "https://github.com/pulumi/pulumi/tree/master/sdk/go";
    license = licenses.asl20;
  };
}
