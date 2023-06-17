{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yamlfmt";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-l081PgSAT9h2oHp1eH96XztcCLeyv1Y11l6lJhHQj1I=";
  };

  vendorHash = "sha256-qrHrLOfyJhsuU75arDtfOhLaLqP+GWTfX+oyLX3aea8=";

  doCheck = false;

  meta = with lib; {
    description = "An extensible command line tool or library to format yaml files.";
    homepage = "https://github.com/google/yamlfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sno2wman ];
  };
}
