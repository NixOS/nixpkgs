{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "rqlite";
  version = "8.28.0";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FhoD88j+uG1AvZ4ce1hwHCFH0cxvlsljf2iv7zAiXLQ=";
  };

  vendorHash = "sha256-WQSdRPU8T02HdKTivLrvdd81XMhqFms0SA0zohicsjA=";

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
