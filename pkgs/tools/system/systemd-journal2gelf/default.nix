{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "SystemdJournal2Gelf-unstable";
  version = "20190702";

  src = fetchFromGitHub {
    rev = "b1aa5ff31307d11a3c9b4dd08c3cd6230d935ec5";
    owner = "parse-nl";
    repo = "SystemdJournal2Gelf";
    sha256 = "0i2pv817fjm2xazxb01dk2gg1xb4d9b6743gqrbsyghbkm7krx29";
  };

  modSha256 = "0f66bjij3bkjs09xhhp26arivlqrd66z1j5ziy4lq4krg82krsdp";

  meta = with stdenv.lib; {
    description = "Export entries from systemd's journal and send them to a graylog server using gelf";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fadenb fpletz globin ];
    platforms = platforms.unix;
  };
}
