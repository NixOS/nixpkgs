{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "controller-tools";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G0jBQ12cpjfWGhXYppV9dB2n68bExi6ME9QbxXsUWvw=";
  };

  patches = [ ./version.patch ];

  postPatch = ''
    # fix wrong go line which go mod tidy complains about
    # https://github.com/kubernetes-sigs/controller-tools/pull/881
    substituteInPlace go.mod \
      --replace-fail "go 1.20" "go 1.21"
  '';

  vendorHash = "sha256-8XSMg/MII+HlsFuaOC6CK/jYiBXfeRZmLT7sW/ZN3Ts=";

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
    changelog = "https://github.com/kubernetes-sigs/controller-tools/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ michojel ];
  };
}
