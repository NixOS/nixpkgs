{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bazel-kazel";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "repo-infra";
    rev = "v${version}";
    sha256 = "sha256-Y9VOlFrFmJQCQuwf3UztHGuJqmq/lSibTbI3oGjtNuE=";
  };

  vendorSha256 = "sha256-1+7Mx1Zh1WolqTpWNe560PRzRYaWVUVLvNvUOysaW5I=";

  doCheck = false;

  subPackages = [ "cmd/kazel" ];

  meta = with lib; {
    description = "kazel - a BUILD file generator for go and bazel";
    homepage = "https://github.com/kubernetes/repo-infra";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
