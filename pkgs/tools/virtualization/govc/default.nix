{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "govc";
<<<<<<< HEAD
  version = "0.30.7";
=======
  version = "0.30.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "govc" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "vmware";
    repo = "govmomi";
<<<<<<< HEAD
    sha256 = "sha256-8cBS92O5AEeXQyLwOTAWbjvj1oPJiHLBooRgl5pt0Mk=";
  };

  vendorHash = "sha256-iLmQdjN0EXJuwC3NT5FKdHhJ4KvNAvnsBGAO9bypdqg=";
=======
    sha256 = "sha256-lYiyZ2sY58bzUtqcM6WIsooLldQAxibASM7xXKAeqJM=";
  };

  vendorHash = "sha256-jbGqQITAhyBLoDa3cKU5gK+4WGgoGSCyFtzeoXx8e7k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vmware/govmomi/govc/flags.BuildVersion=${version}"
  ];

  meta = {
    description = "A vSphere CLI built on top of govmomi";
    homepage = "https://github.com/vmware/govmomi/tree/master/govc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicknovitski ];
  };
}
