{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kopia";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lyCTKjimVZkpXKVeDNn0e9E6FkDp7fUl3cYnn5W5A7o=";
  };

  vendorSha256 = "sha256-p+hK662WoO98J/uE3B9X1GvpnyMGu21sAg8GcyTlWZM=";

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
