{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kafkactl";
<<<<<<< HEAD
  version = "3.3.0";
=======
  version = "3.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Yh+82gtHACTfctnIHQS+t7Pn+eZ5ZY5ySh/ae6g81lU=";
  };

  vendorHash = "sha256-5LHL0L7xTmy3yBs7rtrC1uvUjLKBU8LpjQaHyeRyFhw=";
=======
    hash = "sha256-H6oSkPQx5bk9VBBoeGVg0Ri5LTCv96tR4Vq4guymAbQ=";
  };

  vendorHash = "sha256-Y3BPt3PsedrlCoKiKUObf6UQd+MuNiCGLpJUg94XSgA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
