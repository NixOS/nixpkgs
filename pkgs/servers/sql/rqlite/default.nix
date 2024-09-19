{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "rqlite";
  version = "8.30.3";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W5/e22Qc/qHHHAtsTD9isUkdZ1j4Wk0g56uuAGbE4cU=";
  };

  vendorHash = "sha256-P8v0vqxOfN9JjwsdoM6JmqGujGP5V68OAUc3KB/YU+k=";

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
    description = "Lightweight, distributed relational database built on SQLite";
    homepage = "https://github.com/rqlite/rqlite";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
