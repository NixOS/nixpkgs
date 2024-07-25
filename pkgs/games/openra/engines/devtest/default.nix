{ buildOpenRAEngine }:

buildOpenRAEngine {
  build = "devtest";
  version = "20230414";
  sha256 = "sha256-NU7NEINyrXSkEI5f3q0FLDve1NkNtr0Gww8E8WF9f5A=";
  deps = ./deps.nix;
}
