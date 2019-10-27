{ roundcubePlugin, fetchFromGitHub }:

roundcubePlugin rec {
  pname = "persistent_login";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "mfreiholz";
    repo = pname;
    rev = "version-${version}";
    sha256 = "1k2jgbshwig8q5l440y59pgwbfbc0pdrjbpihba834a4pm0y6anl";
  };
}
