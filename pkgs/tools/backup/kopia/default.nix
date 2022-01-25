{ lib, buildGo117Module, fetchFromGitHub }:

buildGo117Module rec {
  pname = "kopia";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-445E+RiYlfDNOuw51Wdsavb52RjL3FkcrN9EeKmJ+Q8=";
  };

  vendorSha256 = "sha256-wq/9MUCeJBZjrg0SXgHYMyXodqIF3KLRHQmvi7gbv5M=";

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
