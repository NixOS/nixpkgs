{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kafkactl";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZEXW9nqkR0yuVIY9qr1RyKVE7tSlP59Xb4JZfdAK2To=";
  };

  vendorHash = "sha256-e7SJjDWcHPgupZujeRD3Zg6vFAudDC3V60R2B61fjGU=";
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
