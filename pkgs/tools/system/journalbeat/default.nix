{ lib, pkgs, buildGoPackage, fetchFromGitHub, makeWrapper }:

let

  libPath = lib.makeLibraryPath [ pkgs.systemd.lib ];

in buildGoPackage rec {

  name = "journalbeat-${version}";
  version = "5.6.8";

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
    sha256 = "1vgpwnwqjc93nvdpcd52748bwl3r371jb55l17bsgdzrmlcyfm8a";
  };

  meta = with lib; {
    homepage = https://github.com/mheese/journalbeat;
    description = "Journalbeat is a log shipper from systemd/journald to Logstash/Elasticsearch";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbrgm ];
  };
}
