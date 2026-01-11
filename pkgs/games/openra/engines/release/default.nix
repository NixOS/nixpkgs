{ buildOpenRAEngine, dotnetCorePackages }:

buildOpenRAEngine {
  build = "release";
  version = "20250330";
  hash = "sha256-chWkzn/NLZh2gOua9kE0ubRGjGCC0LvtZSWHBgXKqHw=";
  deps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_6_0-bin;
}
