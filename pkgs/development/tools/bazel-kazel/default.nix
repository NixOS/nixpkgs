{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bazel-kazel";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "repo-infra";
    rev = "v${version}";
    sha256 = "0g4lgz5xgmxabaa8pygmdnrnslfrcb84vgr6bninl9v5zz4wajbm";
  };

  vendorSha256 = "1lizvg9r7cck1cgk20np2syv4ljbc0zj1kydiiajf7y5x7d3lwha";

  subPackages = [ "cmd/kazel" ];

  meta = with lib; {
    description = "kazel - a BUILD file generator for go and bazel";
    homepage = "https://github.com/kubernetes/repo-infra";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
