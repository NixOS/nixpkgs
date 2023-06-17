{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "SystemdJournal2Gelf";
  version = "unstable-2022-02-15";

  src = fetchFromGitHub {
    owner = "parse-nl";
    repo = "SystemdJournal2Gelf";
    rev = "86f9f41b26b6848345c2424fbf1ff907b876bb5b";
    sha256 = "sha256-xsrKuZVN6Eb0vG98LbQnFqNxHthv+uL/h2HCDiFY0Oo=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  doCheck = false;

  meta = with lib; {
    description = "Export entries from systemd's journal and send them to a graylog server using gelf";
    homepage = "https://github.com/parse-nl/SystemdJournal2Gelf";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fadenb fpletz ];
    platforms = platforms.unix;
  };
}
