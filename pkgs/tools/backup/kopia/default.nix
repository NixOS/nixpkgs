{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kopia";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-q22iK467dCW9y0ephVA+V9L9drO2631l4cLlphhdwnQ=";
  };

  vendorHash = "sha256-5lm3N9F1Pe/lSA63qk8/azo5FZzTvJE/Is2N9WKT+7k=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/kopia/kopia/repo.BuildVersion=${version}"
    "-X github.com/kopia/kopia/repo.BuildInfo=${src.rev}"
  ];

  meta = with lib; {
    homepage = "https://kopia.io";
    description = "Cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication";
    mainProgram = "kopia";
    license = licenses.asl20;
    maintainers = [ maintainers.bbigras ];
  };
}
