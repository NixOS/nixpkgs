{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gosec";
  version = "2.8.1";

  subPackages = [ "cmd/gosec" ];

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AlADSEekcUH/pCGggKlkBDiIYMe1zsoe9hh6fVUwQVA=";
  };

  vendorSha256 = "sha256-HBwIZfvkL9HSwkD1sZzBM7IJFAjLbCxyc95vqR5TFAg=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.Version=${version}" "-X main.GitTag=${src.rev}" "-X main.BuildDate=unknown" ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
