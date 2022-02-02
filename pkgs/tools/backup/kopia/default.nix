{ lib, buildGo117Module, fetchFromGitHub }:

buildGo117Module rec {
  pname = "kopia";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FdLQI+MbGaO0Kj6icUmcvPzo3rC7mbHYC1xoGv/FzPk=";
  };

  vendorSha256 = "sha256-7QgD4kMiULE2G+/FIqe19kZGvJDEXBY27bEfxabD+ic=";

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
