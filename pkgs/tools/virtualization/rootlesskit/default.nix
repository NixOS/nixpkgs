{ lib, buildGoModule, fetchFromGitHub, nix-update-script, nixosTests }:

buildGoModule rec {
  pname = "rootlesskit";
<<<<<<< HEAD
  version = "1.1.1";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QjGjP7GiJiP2bJE707Oc4wZ9o/gRmSboK9xGbbyG5EM=";
  };

  vendorHash = "sha256-mNuj4/e1qH3P5MfbwPLddXWhc8aDcQuoSSHZ+S+zKWw=";
=======
    hash = "sha256-pIxjesfkHWc7kz4knHxLnzopxO26dBAd/3+wVQ19oiI=";
  };

  vendorSha256 = "sha256-ILGUJsfG60qVu1RWoe8gwjVDfhPoAVZck0CVORgN2y0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru = {
    updateScript = nix-update-script { };
    tests = nixosTests.docker-rootless;
  };

  meta = with lib; {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
