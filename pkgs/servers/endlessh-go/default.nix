{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "endlessh-go";
<<<<<<< HEAD
  version = "20230625-3";
=======
  version = "20230211";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-ug01nwlUCKe7DkhSJJ9XUU4QHZeH0A2f/oH6wl2VzIc=";
  };

  vendorHash = "sha256-n7lzSLtR3bUslT6Q1khsFeofSvwuSaBv3n33+HIdssU=";
=======
    sha256 = "sha256-hG+WIp7JzlHVHjVUouPoocRLpwxWl6hpNorMvc4MsWM=";
  };

  vendorHash = "sha256-zhkQ3v8oN0hu3siu7yVxsFVTnNvJV59tHGpfXZzE+O4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" ];

  passthru.tests = nixosTests.endlessh-go;

  meta = with lib; {
    description = "An implementation of endlessh exporting Prometheus metrics";
    homepage = "https://github.com/shizunge/endlessh-go";
    changelog = "https://github.com/shizunge/endlessh-go/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
  };
}
