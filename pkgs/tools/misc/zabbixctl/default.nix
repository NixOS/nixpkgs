{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "zabbixctl";
  version = "unstable-2019-07-06";

  goPackagePath = "github.com/kovetskiy/zabbixctl";

  src = fetchFromGitHub {
    owner = "kovetskiy";
    repo = pname;
    rev = "f2e856b7ab7d8ff9f494fe9f481bbaef18ea6ff7";
    sha256 = "1lr3g9h3aa2px2kh5b2qcpj3aqyhqwq7kj1s9wifgmri9q7fsdzy";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Most effective way for operating in Zabbix Server";
    homepage = "https://github.com/kovetskiy/zabbixctl";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mmahut ];
  };
}
