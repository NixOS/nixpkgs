{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "protoc-gen-twirp_typescript";
<<<<<<< HEAD
  version = "unstable-2022-08-14";
=======
  version = "unstable-2021-03-29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "larrymyers";
    repo = "protoc-gen-twirp_typescript";
<<<<<<< HEAD
    rev = "535986b31881a214db3c04f122bcc96a2823a155";
    sha256 = "sha256-LfF/n96LwRX8aoPHzCRI/QbDmZR9yMhE5yGhFAqa8nA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-UyxHa28SY60U8VeL7TbSTyscqN5T7tKGfuN2GIL6QIg";
=======
    rev = "97fd63e543beb2d9f6a90ff894981affe0f2faf1";
    sha256 = "sha256-LfF/n96LwRX8aoPHzCRI/QbDmZR9yMhE5yGhFAqa8nA=";
  };

  vendorSha256 = "sha256-WISWuq1neVX4xQkoamc6FznZahOQHwgkYmERJF40OFQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "Protobuf Plugin for Generating a Twirp Typescript Client";
    homepage = "https://github.com/larrymyers/protoc-gen-twirp_typescript";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ jojosch dgollings ];
=======
    maintainers = with maintainers; [ jojosch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
