{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "bazel-kazel";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "repo-infra";
    rev = "v${version}";
    sha256 = "121asn0h2vfgqnjk72wqjcfq0w15k15abjdm39i8hv455kzrc2hs";
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
