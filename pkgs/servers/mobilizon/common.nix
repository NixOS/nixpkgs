{ fetchFromGitLab }:
rec {

  pname = "mobilizon";
  version = "5.1.4";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "kaihuri";
    repo = pname;
    tag = version;
    sha256 = "sha256-rtYb9wptP1wAaQrK60apjjSCqtfolXag6QgRYf6pwzQ=";
  };
}
