{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "rqlite";
  version = "8.13.2";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YwwA9oqMJuHWaJ7zcSLJjbq3urIyUe6aZZS4kEeq7/8=";
  };

  vendorHash = "sha256-qNI3SJdgaBi78Tvsd+RJ52vKZrbUQdEaEG/zTDKX0J4=";

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
