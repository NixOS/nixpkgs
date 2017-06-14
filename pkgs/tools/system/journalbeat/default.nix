{ lib, pkgs, buildGoPackage, fetchFromGitHub, makeWrapper }:

let

  libPath = lib.makeLibraryPath [ pkgs.systemd.lib ];

in buildGoPackage rec {

  name = "journalbeat-${version}";
  version = "5.4.1";

  goPackagePath = "github.com/mheese/journalbeat";

  buildInputs = [ makeWrapper pkgs.systemd ];

  postInstall = ''
    wrapProgram $bin/bin/journalbeat \
      --prefix LD_LIBRARY_PATH : ${libPath}
  '';

  src = fetchFromGitHub {
    owner = "mheese";
    repo = "journalbeat";
    rev = "v${version}";
    sha256 = "14mhx3gqg19ljcr07ahbry9k5hkbj2mjji4qsjrbc7jknis6frz4";
  };

  meta = with lib; {
    homepage = https://github.com/mheese/journalbeat;
    description = "Journalbeat is a log shipper from systemd/journald to Logstash/Elasticsearch";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbrgm ];
  };
}
