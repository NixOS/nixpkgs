{ lib, pkgs, buildGoPackage, fetchFromGitHub, makeWrapper }:

let

  libPath = lib.makeLibraryPath [ pkgs.systemd.lib ];

in buildGoPackage rec {

  name = "journalbeat-${version}";
  version = "5.6.0";

  goPackagePath = "github.com/mheese/journalbeat";

  buildInputs = [ makeWrapper pkgs.systemd ];

  postInstall = ''
    wrapProgram $bin/bin/journalbeat \
      --argv0 journalbeat \
      --prefix LD_LIBRARY_PATH : ${libPath}
  '';

  src = fetchFromGitHub {
    owner = "mheese";
    repo = "journalbeat";
    rev = "v${version}";
    sha256 = "0b5yqzw1h945mwwyy7cza6bc7kzv3x1p9w2xkzmvr7rw3pd32r06";
  };

  meta = with lib; {
    homepage = https://github.com/mheese/journalbeat;
    description = "Journalbeat is a log shipper from systemd/journald to Logstash/Elasticsearch";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbrgm ];
  };
}
