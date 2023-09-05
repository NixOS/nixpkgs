{ fetchFromGitLab }: rec {

  pname = "mobilizon";
  version = "3.1.3";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "framasoft";
    repo = pname;
    rev = version;
    sha256 = "sha256-vYn8wE3cwOH3VssPDKKWAV9ZLKMSGg6XVWFZzJ9HSw0=";
  };

}
