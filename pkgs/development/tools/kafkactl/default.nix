{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kafkactl";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W+4JLJIc/wkT8cu5GYx1YpnbBBe3XboMTFihvrmDmR0=";
  };

  vendorSha256 = "sha256-ba7amhYuCB3k1esu1qYBCgUZMjlq5iac498TMqeGuz0=";
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
