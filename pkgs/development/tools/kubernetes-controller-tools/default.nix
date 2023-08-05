{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "controller-tools";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OqBTlzHqnwu6GaNFS6cdcOoBNdSGus/piR4tXRfzpn0=";
  };

  patches = [ ./version.patch ];

  vendorHash = "sha256-gztTF8UZ5N4mip8NIyuCfoy16kpJymtggfG0sAcZW6c=";

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
