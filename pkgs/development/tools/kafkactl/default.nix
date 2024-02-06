{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kafkactl";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HGOLPns7kBq02hF5TVs0DdTdJ+16JGs996JZ66k83Os=";
  };

  vendorHash = "sha256-jUuJBGEb4pSdyuRd3qHINyC8aRwqyJnsb/raM9nEh84=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/deviceinsight/kafkactl";
    changelog = "https://github.com/deviceinsight/kafkactl/blob/v${version}/CHANGELOG.md";
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
  };
}
