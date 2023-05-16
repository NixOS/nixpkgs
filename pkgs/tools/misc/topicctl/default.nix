{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "topicctl";
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Ag8ZQT6ugLMDTZwY6A69B+WDpLWMtBBtpg8m1a09N4I=";
=======
    sha256 = "sha256-R6Dw6/pgXUmQrq8iD93h64VVEvB4TBEcGb2Rbg6kTp0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-UJ7U9CfQHKgK7wfb8zqLZ7na4OBBZBYiGayII3RTaiQ=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

  meta = with lib; {
    description = "A tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ];
  };
}
