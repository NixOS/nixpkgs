{ lib
, fetchFromGitHub
, buildDartApplication
}:

buildDartApplication rec {
  pname = "protoc-gen-dart";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf.dart";
    rev = "protobuf-v${version}";
    sha256 = "sha256-uBQ8s1NBSWm88mpLfZwobTe/BDDT6UymSra88oUuPIA=";
  };
  sourceRoot = "source/protoc_plugin";

  pubspecLockFile = ./pubspec.lock;
  vendorHash = "sha256-jyhHZ1OUFo6ce3C5jEQPqmtRL4hr2nTfgVMR0k6AXtM=";

  meta = with lib; {
    description = "Protobuf plugin for generating Dart code";
    homepage = "https://pub.dev/packages/protoc_plugin";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lelgenio ];
  };
}
