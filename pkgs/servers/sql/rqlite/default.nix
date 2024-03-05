{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "rqlite";
  version = "8.22.1";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g5W+rHD4gUS82E+wFLQ3VTSwIWQUogwTutwPTtf+IdM=";
  };

  vendorHash = "sha256-onR4n6ok6y9APRwGjBoMISbidGDVw19D48TkogRp1uM=";

  subPackages = [ "cmd/rqlite" "cmd/rqlited" "cmd/rqbench" ];

  # Leaving other flags from https://github.com/rqlite/rqlite/blob/master/package.sh
  # since automatically retriving those is nontrivial and inessential
  ldflags = [
    "-s" "-w"
    "-X github.com/rqlite/rqlite/cmd.Version=${src.rev}"
  ];

  # Tests are in a different subPackage which fails trying to access the network
  doCheck = false;

  meta = with lib; {
    description = "The lightweight, distributed relational database built on SQLite";
    homepage = "https://github.com/rqlite/rqlite";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
