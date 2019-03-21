{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "SystemdJournal2Gelf-${version}";
  version = "20170413";

  goPackagePath = "github.com/parse-nl/SystemdJournal2Gelf";

  src = fetchFromGitHub {
    rev = "862b1d60d2ba12cd8480304ca95041066cc8bdd0";
    owner = "parse-nl";
    repo = "SystemdJournal2Gelf";
    sha256 = "0xvvc7w2sxkhb33nkq5v626l673d5j2z0yc75wvmqzncwfkkv94v";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Export entries from systemd's journal and send them to a graylog server using gelf";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fadenb fpletz globin ];
    platforms = platforms.unix;
  };
}
