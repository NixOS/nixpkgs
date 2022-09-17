{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kopia";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BdWxNJr5RofpblvKKQXtdA49pLD6MKlEi3XViIpt4Ww=";
  };

  vendorSha256 = "sha256-ZLVBYosPvININQsqU2hy25vtUfW1mRjipm7VykVLV7w=";

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
