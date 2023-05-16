{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
, testers
, sish
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "sish";
<<<<<<< HEAD
  version = "2.9.2";
=======
  version = "2.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-6PCZtiXsDQfPZFw3r1n3rwgxigSnWgggHXzZdBT/fxA=";
  };

  vendorHash = "sha256-RnvkEUvL/bQTTTlg0RF0xjjvVniltequNKRD3z0H3O8=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/antoniomika/sish/cmd.Commit=${src.rev}"
    "-X=github.com/antoniomika/sish/cmd.Date=1970-01-01"
    "-X=github.com/antoniomika/sish/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = sish;
    };
  };
=======
    rev = "v${version}";
    sha256 = "sha256-BzWpEkhLhTNt5C/1G0Hnkli2kMvRwGbRc1bCgsWdRUo=";
  };

  vendorSha256 = "sha256-SQKkhyUYuOuPb8SOtjgRTsGKg6T75Zcot5ufHSUaiCM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
<<<<<<< HEAD
    changelog = "https://github.com/antoniomika/sish/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
