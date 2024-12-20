{ fetchFromGitLab }: rec {

  pname = "mobilizon";
  version = "5.1.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "framasoft";
    repo = pname;
    rev = version;
    sha256 = "sha256-2L1k8oaO9EDWlYO+OIlkbEcqPYN1fac0MpnpNHkoeis=";
  };
}
