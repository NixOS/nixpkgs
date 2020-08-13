{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bazel-kazel";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "repo-infra";
    rev = "v${version}";
    sha256 = "0fcm7gjsv70qxnwbgy2sgx7clyhlfnkvdxsjgcrkaf5xds8hpys7";
  };

  vendorSha256 = "1pzkjh4n9ai8yqi98bkdhicjdr2l8j3fckl5n90c2gdcwqyxvgkf";

  doCheck = false;

  subPackages = [ "cmd/kazel" ];

  meta = with lib; {
    description = "kazel - a BUILD file generator for go and bazel";
    homepage = "https://github.com/kubernetes/repo-infra";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
  };
}
