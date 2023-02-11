{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "controller-tools";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F+cGJbxXIHrgn9OcIMh2am9g4PBLkdC037tV/9znPSg=";
  };

  patches = [ ./version.patch ];

  vendorHash = "sha256-nZyDoME5fVqRoAeLADjrQ7i6mVf3ujGN2+BUfrSHck8=";

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
