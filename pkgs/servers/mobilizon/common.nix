{ fetchFromGitLab }:
rec {

  pname = "mobilizon";
  version = "5.1.5";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "kaihuri";
    repo = pname;
    tag = version;
    hash = "sha256-nwEmW43GO0Ta7O7mUSJaEtm4hBfXInPqatBRdaWrhBU=";
  };
}
