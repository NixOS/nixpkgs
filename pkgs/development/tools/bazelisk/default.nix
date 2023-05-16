{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
<<<<<<< HEAD
  version = "1.18.0";
=======
  version = "1.16.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-NZDdSIXNQFSCoav+YN1VLFrHQSKZfoZDp2TWXtmQC6o=";
  };

  vendorHash = "sha256-oYagIEb/u/XCTbZkvynxcOtORhW75hReinrVAkdOApM=";
=======
    sha256 = "sha256-ijw0JVU9jUhpIJQjcjgzAVPJDxD7WSZYiLV0OvOyS5g=";
  };

  vendorHash = "sha256-Hg8rMknanHQOgVLJ58QM9JOgrUYMqL7WvaHuiv9xVYw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.BazeliskVersion=${version}" ];

  meta = with lib; {
    description = "A user-friendly launcher for Bazel";
    longDescription = ''
      BEWARE: This package does not work on NixOS.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
<<<<<<< HEAD
    changelog = "https://github.com/bazelbuild/bazelisk/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
