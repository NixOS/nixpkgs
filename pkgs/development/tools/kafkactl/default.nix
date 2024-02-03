{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kafkactl";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8/MqcJ7kxlmVkZCa7PWZ6kzo6D/9Zwx2rOJs675mJUE=";
  };

  vendorHash = "sha256-5LHL0L7xTmy3yBs7rtrC1uvUjLKBU8LpjQaHyeRyFhw=";

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
