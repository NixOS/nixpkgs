{ buildOpenRAEngine }:

buildOpenRAEngine {
  build = "playtest";
  version = "20230927";
  sha256 = "sha256-gH6jaK3ne52kPhCcmte7Pu4jxeUTvvTeDiBfFYVC+5k=";
  deps = ./deps.nix;
}
