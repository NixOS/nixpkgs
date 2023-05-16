{ lib
, buildGoModule
, pulumi
}:
buildGoModule rec {
  pname = "pulumi-language-go";
  inherit (pulumi) version src;

<<<<<<< HEAD
  sourceRoot = "${src.name}/sdk/go/pulumi-language-go";

  vendorHash = "sha256-6/umLzw7HMplP/cJknBsWmiwAnc+YM4tIz4Zl2QMTOQ=";
=======
  sourceRoot = "${src.name}/sdk";

  vendorHash = pulumi.sdkVendorHash;

  subPackages = [
    "go/pulumi-language-go"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];
<<<<<<< HEAD

  # go: inconsistent vendoring in ...
  doCheck = false;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Golang language host plugin for Pulumi";
    homepage = "https://github.com/pulumi/pulumi/tree/master/sdk/go";
    license = licenses.asl20;
  };
}
