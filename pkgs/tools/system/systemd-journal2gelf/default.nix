{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "SystemdJournal2Gelf-unstable";
  version = "20200813";

  src = fetchFromGitHub {
    rev = "d389dc8583b752cbd37c389a55a6c82200e47394";
    owner = "parse-nl";
    repo = "SystemdJournal2Gelf";
    sha256 = "0p38r5kdfcn6n2d44dygrs5xgv51s5qlsfhzzwn16r3n6x91s62b";
    fetchSubmodules = true;
  };

  goPackagePath = "github.com/parse-nl/SystemdJournal2Gelf";

  meta = with lib; {
    description = "Export entries from systemd's journal and send them to a graylog server using gelf";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fadenb fpletz ];
    platforms = platforms.unix;
  };
}
