{ roundcubePlugin, fetchFromGitHub }:

roundcubePlugin rec {
  pname = "persistent_login";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "mfreiholz";
    repo = pname;
    rev = "version-${version}";
    sha256 = "1qf7q1sypwa800pgxa3bg6ngcpkf4dqgg6jqx8cnd6cb7ikbfldb";
  };
}
