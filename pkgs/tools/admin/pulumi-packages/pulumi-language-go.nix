{ lib
, buildGoModule
, pulumi
}:
buildGoModule rec {
  pname = "pulumi-language-go";
  inherit (pulumi) version src;

  sourceRoot = "${src.name}/sdk/go/pulumi-language-go";

  vendorHash = "sha256-Bk/JxFYBnd+bOlExJKGMIl2oUHPg3ViIVBqKBojoEm4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  # go: inconsistent vendoring in ...
  doCheck = false;

  meta = with lib; {
    description = "Golang language host plugin for Pulumi";
    mainProgram = "pulumi-language-go";
    homepage = "https://github.com/pulumi/pulumi/tree/master/sdk/go";
    license = licenses.asl20;
  };
}
