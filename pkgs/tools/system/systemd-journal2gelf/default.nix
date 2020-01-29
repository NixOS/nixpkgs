{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "SystemdJournal2Gelf-unstable";
  version = "20190702";

  src = fetchFromGitHub {
    rev = "b1aa5ff31307d11a3c9b4dd08c3cd6230d935ec5";
    owner = "parse-nl";
    repo = "SystemdJournal2Gelf";
    sha256 = "13jyh34wprjixinmh6l7wj7lr1f6qy6nrjcf8l29a74mczbphnvv";
    fetchSubmodules = true;
  };

  goPackagePath = "github.com/parse-nl/SystemdJournal2Gelf";

  meta = with stdenv.lib; {
    description = "Export entries from systemd's journal and send them to a graylog server using gelf";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fadenb fpletz ];
    platforms = platforms.unix;
  };
}
