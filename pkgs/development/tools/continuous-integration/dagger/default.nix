{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dagger";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "dagger";
    repo = "dagger";
    rev = "v${version}";
    sha256 = "sha256-sy4z/kyHUn9OSkB1uYQsmr/T5ij/0HfTrr0sIyIUGTE=";
  };

  vendorSha256 = "sha256-l2Ydj7snWQa7L1uVQxBqtj9DsrH+ayUhlsiwDJSeOWk=";

  subPackages = [
    "cmd/dagger"
  ];

  ldflags = [ "-s" "-w" "-X go.dagger.io/dagger/version.Revision=${version}" ];

  meta = with lib; {
    description = "A portable devkit for CICD pipelines";
    homepage = "https://dagger.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfroche ];
  };
}
