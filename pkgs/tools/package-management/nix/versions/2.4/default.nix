{ common
, fetchurl
, ...
}:

common {
  version = "2.4";
  hash = "sha256-op48CCDgLHK0qV1Batz4Ln5FqBiRjlE6qHTiZgt3b6k=";
  # https://github.com/NixOS/nix/pull/5537
  patches = [ ../../patches/install-nlohmann_json-headers.patch ];
}

