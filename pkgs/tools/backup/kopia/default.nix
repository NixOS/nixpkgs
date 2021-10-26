{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kopia";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+zfkFusLoYITIStk3ZobeuN3MFeY5T6pbiUEc4IT1UA=";
  };

  vendorSha256 = "sha256-v81YkImg8GdI5locfsU4dg2JyO7XB24mfHRIZ+k8QBA=";

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
