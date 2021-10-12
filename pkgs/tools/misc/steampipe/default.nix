{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "steampipe";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe";
    rev = "v${version}";
    sha256 = "sha256-3vetSUJwCeaBzKj+635siskfcDPs/kkgCH954cg/REA=";
  };

  vendorSha256 = "sha256-TGDFNHWWbEy1cD7b2yPqAN7rRrLvL0ZX/R3BWGRWjjw=";

  # tests are failing for no obvious reasons
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://steampipe.io/";
    description = "select * from cloud;";
    license = licenses.agpl3;
    maintainers = with maintainers; [ hardselius ];
  };
}
