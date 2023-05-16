{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "devspace";
<<<<<<< HEAD
  version = "6.3.3";
=======
  version = "6.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "loft-sh";
    repo = "devspace";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-xAK06bpl8BGsVUu6O1C2l+tzeiCQoRUMIUtwntUZVvU=";
=======
    sha256 = "sha256-TDC4zhsNcU3qwvBSxvaYxlWHXX1YllRX9n6CGKlXOq4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorSha256 = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Check are disable since they requiered a working K8S cluster
  # TODO: add a nixosTest to be able to perform the package check
  doCheck = false;

  meta = with lib; {
    description = "DevSpace is an open-source developer tool for Kubernetes that lets you develop and deploy cloud-native software faster";
    homepage = "https://devspace.sh/";
    changelog = "https://github.com/loft-sh/devspace/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ darkonion0 ];
  };
}
