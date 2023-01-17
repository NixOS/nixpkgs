{ common
, ...
}:

common {
  version = "2.5.1";
  hash = "sha256-GOsiqy9EaTwDn2PLZ4eFj1VkXcBUbqrqHehRE9GuGdU=";
  # https://github.com/NixOS/nix/pull/5536
  patches = [ ../../patches/install-nlohmann_json-headers.patch ];
}

