{ fetchFromGitLab }:
rec {

  pname = "mobilizon";
  version = "5.2.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "kaihuri";
    repo = pname;
    tag = version;
    hash = "sha256-wsiu0f0M0SMjgskMJuA/wUx6IxT7bTzHrOnxX8eFq9g=";
  };
}
