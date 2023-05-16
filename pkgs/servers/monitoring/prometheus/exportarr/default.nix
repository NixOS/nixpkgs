{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "exportarr";
<<<<<<< HEAD
  version = "1.5.3";
=======
  version = "1.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = "exportarr";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pjT4zzYONiHMv0YORHHvsBjBUsFQQ7yKNvUqnvgi2Pk=";
  };

  vendorHash = "sha256-tSdGWtVHtas+3uvQiZhBreY2hODopZepApOVoFsERws=";
=======
    hash = "sha256-99ap7B5EfMhuSGmT/JNI+CTPv7lTdjxibC0ndYWyNoA=";
  };

  vendorHash = "sha256-2Eb8FhbRu5M5u8HGa2bgAvZZkwHycBu8UiNKHG5/fFw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/exportarr" ];

  CGO_ENABLE = 0;

  ldflags = [ "-s" "-w" ];

  tags = lib.optionals stdenv.isLinux [ "netgo" ];

  preCheck = ''
    # Run all tests.
    unset subPackages
  '';

  meta = with lib; {
    description = "AIO Prometheus Exporter for Sonarr, Radarr or Lidarr";
    homepage = "https://github.com/onedr0p/exportarr";
    changelog = "https://github.com/onedr0p/exportarr/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
