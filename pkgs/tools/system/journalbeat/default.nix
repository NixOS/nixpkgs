{ lib, pkgs, buildGoPackage, fetchFromGitHub, makeWrapper }:

let

  libPath = lib.makeLibraryPath [ pkgs.systemd.lib ];

in buildGoPackage rec {

  name = "journalbeat-${version}";
  version = "5.5.0";

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
    sha256 = "134n1kg6nx5yycn2cyldiayaqm8zps94hz4zfz9klp2jzq68m35y";
  };

  meta = with lib; {
    homepage = https://github.com/mheese/journalbeat;
    description = "Journalbeat is a log shipper from systemd/journald to Logstash/Elasticsearch";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbrgm ];
  };
}
