{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kafkactl";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zg0lar16axi25mnmdbdyrm876rbc328kq1yvhjlnzskmkhzjsg2";
  };

  vendorSha256 = "0pnnrpyg40lb54h0k36c4iibapzlh54cdvc4mampmj13kphk3zzg";
  doCheck = false;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Command Line Tool for managing Apache Kafka";
    longDescription = ''
      A command-line interface for interaction with Apache Kafka.
      Features:
      - command auto-completion for bash, zsh, fish shell including dynamic completion for e.g. topics or consumer groups
      - support for avro schemas
      - Configuration of different contexts
      - directly access kafka clusters inside your kubernetes cluster
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ grburst ];
    platforms = platforms.unix;
  };
}
