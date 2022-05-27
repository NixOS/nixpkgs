{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "rqlite";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "rqlite";
    repo = "rqlite";
    rev = "v${version}";
    sha256 = "sha256-qdRSX5QNABuMyBEkYAs16kW26gfl+M7oVygawRGeJUI=";
  };

  vendorSha256 = "sha256-YT1nK1vFmNCRJyWOiQhSJr83qW8uxkHXCZ81/Ch6qpg=";

  modRoot = ".";
  subPackages = [
    # I didn't remove any of the originals ones, it's here to save us time...
    "auth"
    "aws"
    "cluster"
    "cmd"
    "cmd/rqbench"
    "cmd/rqlite"
    "cmd/rqlite/http"
    "cmd/rqlited"
    "command"
    "command/encoding"
    "db"
    "disco"
    "http"
    "log"
    "queue"
    "store"
    "system_test"
    "tcp"
    "tcp/pool"
  ];

  doCheck = false; # Not passing "system_test" that uses the internet.

  meta = with lib; {
    description = "The lightweight, distributed relational database built on SQLite";
    homepage = "https://github.com/rqlite/rqlite";
    license = licenses.mit;
    maintainers = with maintainers; [ pedrohlc ];
    platforms = platforms.unix; # it works in homebrew, so I imagine it works in darwin.
  };
}
