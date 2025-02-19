{ fetchFromGitLab }: rec {

  pname = "mobilizon";
  version = "5.1.1";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "framasoft";
    repo = pname;
    rev = version;
    sha256 = "sha256-zH/F+8rqzlMh0itVBOgDDzAx6n1nJH81lMzaBfjzhXU=";
  };
}
