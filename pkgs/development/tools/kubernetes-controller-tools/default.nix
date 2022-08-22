{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "controller-tools";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fMLydjdL9GCSX2rf7ORW1RhZJpjA0hyeK40AwKTkrxg=";
  };

  vendorSha256 = "sha256-6luowQB/j8ipHSuWMHia8SdacienDzpV8g2JH3k0W80=";

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
