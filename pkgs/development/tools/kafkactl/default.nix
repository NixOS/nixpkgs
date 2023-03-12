{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kafkactl";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-H6oSkPQx5bk9VBBoeGVg0Ri5LTCv96tR4Vq4guymAbQ=";
  };

  vendorHash = "sha256-Y3BPt3PsedrlCoKiKUObf6UQd+MuNiCGLpJUg94XSgA=";

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
    platforms = platforms.unix;
  };
}
