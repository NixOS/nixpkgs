{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bazel-kazel";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "repo-infra";
    rev = "v${version}";
    sha256 = "1l3dz77h58v1sr7k8cabq5bbdif5w96zdcapax69cv1frr9jbrcb";
  };

  vendorSha256 = "1pzkjh4n9ai8yqi98bkdhicjdr2l8j3fckl5n90c2gdcwqyxvgkf";

  subPackages = [ "cmd/kazel" ];

  meta = with lib; {
    description = "kazel - a BUILD file generator for go and bazel";
    homepage = "https://github.com/kubernetes/repo-infra";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
