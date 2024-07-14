{ fetchFromGitLab }: rec {

  pname = "mobilizon";
  version = "4.1.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "framasoft";
    repo = pname;
    rev = version;
    sha256 = "sha256-aS57126Nhz/QvouSyZ9wUu78/eoCYbRwyncUUmO1Dv8=";
  };
}
