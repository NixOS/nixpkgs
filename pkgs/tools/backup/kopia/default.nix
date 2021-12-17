{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kopia";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nHMsh+2Wpca2SJSy1XRMWwHHcdjpnb1u9JS6wM4E65Y=";
  };

  vendorSha256 = "sha256-SJKsTZMppu6eit4ssMSwJOkeaheEYUwWRDPyPjirNHM=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/kopia/kopia/repo.BuildVersion=${version}"
    "-X github.com/kopia/kopia/repo.BuildInfo=${src.rev}"
  ];

  meta = with lib; {
    homepage = "https://kopia.io";
    description = "Cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication";
    license = licenses.asl20;
    maintainers = [ maintainers.bbigras ];
  };
}
