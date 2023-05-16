<<<<<<< HEAD
{ buildGoModule
=======
{ lib
, buildGoModule
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pulumi
, nodejs
}:
buildGoModule rec {
  inherit (pulumi) version src sdkVendorHash;

  pname = "pulumi-language-nodejs";

<<<<<<< HEAD
  sourceRoot = "${src.name}/sdk/nodejs/cmd/pulumi-language-nodejs";

  vendorHash = "sha256-3kDWb+1aebV2D+Nm5bkhKrJZMe/lD0ltFQ7p+Bfk644=";
=======
  sourceRoot = "${src.name}/sdk";

  vendorHash = sdkVendorHash;

  subPackages = [
    "nodejs/cmd/pulumi-language-nodejs"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/pulumi/sdk/v3/go/common/version.Version=${version}"
  ];

  nativeCheckInputs = [
    nodejs
  ];
<<<<<<< HEAD
=======

  postInstall = ''
    cp nodejs/dist/pulumi-resource-pulumi-nodejs $out/bin
    cp nodejs/dist/pulumi-analyzer-policy $out/bin
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
