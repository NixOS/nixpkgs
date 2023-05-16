{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "flannel";
<<<<<<< HEAD
  version = "0.22.2";
  rev = "v${version}";

  vendorHash = "sha256-sObAXI9U5U1JXWNzaBNNGfklnfh/G3aUye/MINWwU4s=";
=======
  version = "0.21.5";
  rev = "v${version}";

  vendorHash = "sha256-JtDFwkYRAxpa4OBV5Tzr70DcOsp2oA3XB0PM5kGaY6Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
<<<<<<< HEAD
    sha256 = "sha256-ZQyBPsYIOQq6oonn661sIBpccV9uxoXlieOhbIIv5AE=";
  };

  ldflags = [ "-X github.com/flannel-io/flannel/pkg/version.Version=${rev}" ];
=======
    sha256 = "sha256-X8NVAaKJrJF1OCfzwcydvDPFUOhwdgGy/wfMWdhUqQ0=";
  };

  ldflags = [ "-X github.com/flannel-io/flannel/version.Version=${rev}" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # TestRouteCache/TestV6RouteCache fail with "Failed to create newns: operation not permitted"
  doCheck = false;

  passthru.tests = { inherit (nixosTests) flannel; };

  meta = with lib; {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = "https://github.com/flannel-io/flannel";
    maintainers = with maintainers; [ johanot offline ];
    platforms = with platforms; linux;
  };
}
