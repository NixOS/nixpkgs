{ lib
, fetchFromGitHub
, buildDartApplication
}:

buildDartApplication rec {
  pname = "protoc-gen-dart";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf.dart";
    rev = "protobuf-v${version}";
    sha256 = "sha256-2QnLS6GHhDHMCnAY+2c1wMyPY3EKtlijWHQC+9AVt0k=";
  };
  sourceRoot = "${src.name}/protoc_plugin";

  pubspecLockFile = ./pubspec.lock;
  vendorHash = "sha256-yNgQLCLDCbA07v9tIwPRks/xPAzLVykNtIk+8C0twYM=";

  meta = with lib; {
    description = "Protobuf plugin for generating Dart code";
    homepage = "https://pub.dev/packages/protoc_plugin";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lelgenio ];
  };
}
