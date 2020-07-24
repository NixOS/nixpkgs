{ roundcubePlugin, fetchFromGitHub }:

roundcubePlugin rec {
  pname = "persistent_login";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "mfreiholz";
    repo = pname;
    rev = "version-${version}";
    sha256 = "0aasc2ns318s1g8vf2hhqwsplchhrhv5cd725rnfldim1y8k0n1i";
  };
}
