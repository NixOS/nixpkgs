{ fetchFromGitLab }:
rec {

  pname = "mobilizon";
  version = "5.2.2";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "kaihuri";
    repo = pname;
    tag = version;
    hash = "sha256-SPkkanqEuxcZ7x0rqRk0pcB2c2rg08DcTO+SWP4cEqk=";
  };
}
