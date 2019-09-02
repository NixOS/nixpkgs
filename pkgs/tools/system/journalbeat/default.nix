{ lib, systemd, buildGoPackage, fetchFromGitHub, makeWrapper }:

buildGoPackage rec {
  name = "journalbeat-${version}";
  version = "5.6.8";

  src = fetchFromGitHub {
    owner = "mheese";
    repo = "journalbeat";
    rev = "v${version}";
    sha256 = "1vgpwnwqjc93nvdpcd52748bwl3r371jb55l17bsgdzrmlcyfm8a";
  };

  goPackagePath = "github.com/mheese/journalbeat";

  buildInputs = [ systemd.dev ];

  postFixup = let libPath = lib.makeLibraryPath [ systemd.lib ]; in ''
    patchelf --set-rpath ${libPath} "$bin/bin/journalbeat"
  '';

  meta = with lib; {
    homepage = https://github.com/mheese/journalbeat;
    description = "Journalbeat is a log shipper from systemd/journald to Logstash/Elasticsearch";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbrgm ];
  };
}
