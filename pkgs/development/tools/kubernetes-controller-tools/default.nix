{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "controller-tools";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-strTBBpmG60H38WWLakIjZHVUgKC/ajS7ZEFDhZWnlo=";
=======
    sha256 = "sha256-2nRsaHCqZUF3M1Z0e//IjhYELHRxR6fSCfkWyC1fog4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [ ./version.patch ];

<<<<<<< HEAD
  vendorHash = "sha256-YQfMq0p3HfLgOjAk/anZpGx/fDnvovI3HtmYdKRKq5w=";
=======
  vendorHash = "sha256-gztTF8UZ5N4mip8NIyuCfoy16kpJymtggfG0sAcZW6c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/controller-tools/pkg/version.version=v${version}"
  ];

  doCheck = false;

  subPackages = [
    "cmd/controller-gen"
    "cmd/type-scaffold"
    "cmd/helpgen"
  ];

  meta = with lib; {
    description = "Tools to use with the Kubernetes controller-runtime libraries";
    homepage = "https://github.com/kubernetes-sigs/controller-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ michojel ];
  };
}
