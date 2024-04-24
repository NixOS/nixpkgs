{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kafkactl";
  version = "5.0.6";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pAi60t0mtRlAL+z6s5moWwxw0hC6CeiljjjFyzyN+nI=";
  };

  vendorHash = "sha256-7ibev9Po8is+PXH0BC8ZLiTMJsPMR6VUwjNA/c1y/g0=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/deviceinsight/kafkactl";
    changelog = "https://github.com/deviceinsight/kafkactl/blob/v${version}/CHANGELOG.md";
    description = "Command Line Tool for managing Apache Kafka";
    mainProgram = "kafkactl";
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
