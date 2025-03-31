{ buildOpenRAEngine }:

buildOpenRAEngine {
  build = "release";
  version = "20231010";
  hash = "sha256-klJkRoDLTcU7j2iwo4yT9CaKy8QXWDkYw7ApkopSDNM=";
  deps = ./deps.json;
}
