{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "rqlite";
  version = "8.26.6";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mn6rju0DioW2xI9tz0e9Sy4H4tg6StpYn7NjJRxzfAI=";
  };

  vendorHash = "sha256-bzK6PYSg9z1QS+5Vk6pPM10ddrLVRm0C7rmepZt4b0M=";

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
