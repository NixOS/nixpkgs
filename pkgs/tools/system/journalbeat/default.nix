{ lib, pkgs, buildGoPackage, fetchFromGitHub, makeWrapper }:

let

  libPath = lib.makeLibraryPath [ pkgs.systemd.lib ];

in buildGoPackage rec {

  name = "journalbeat-${version}";
  version = "5.1.2";

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
    sha256 = "179jayzvd5k4mwhn73yflbzl5md1fmv7a9hb8vz2ir76lvr33g3l";
  };

  meta = with lib; {
    homepage = https://github.com/mheese/journalbeat;
    description = "Journalbeat is a log shipper from systemd/journald to Logstash/Elasticsearch";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbrgm ];
  };
}
