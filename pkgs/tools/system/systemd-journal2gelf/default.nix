{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "SystemdJournal2Gelf-${version}";
  version = "20160414";

  goPackagePath = "github.com/parse-nl/SystemdJournal2Gelf";

  src = fetchFromGitHub {
    rev = "aba2f24e59f190ab8830bf40f92f890e62a9ec9f";
    owner = "parse-nl";
    repo = "SystemdJournal2Gelf";
    sha256 = "012fmnb44681dgz21n1dlb6vh923bpk5lkqir1q40kfz6pacq64n";
  };

  goDeps = ./deps.json;

  meta = with stdenv.lib; {
    description = "Export entries from systemd's journal and send them to a graylog server using gelf";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fadenb fpletz globin ];
    platforms = platforms.linux;
  };
}
