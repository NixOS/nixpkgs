{ lib, buildGo117Module, fetchFromGitHub }:

buildGo117Module rec {
  pname = "kopia";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7Bvgtp6egZqpTv4Ac+OUkhKzTZhRRMwpdvwOCBA6Dso=";
  };

  vendorSha256 = "sha256-/dCRM61Zl5YbIb0mKhcyLU15nQhR31QAaq+5TwRK4pM=";

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
