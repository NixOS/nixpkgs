{
  fetchzip,
  revision,
  system,
  throwSystem,
}:
let
  download =
    (import ./browser-downloads.nix {
      name = "ffmpeg";
      inherit revision;
    }).${system} or throwSystem;
in
fetchzip {
  inherit (download) url stripRoot;
  hash =
    {
      x86_64-linux = "sha256-5+WbgtmcKkTaSurejqzkkglNI/0dW7ePxbltOeCiakI=";
      aarch64-linux = "sha256-OTpALfzK0fIjWHaywNVGWwwAaRncYElcV//En3/oOVI=";
      aarch64-darwin = "sha256-runukRDgLHIcOLqR/O8Kd3N7q73hXUc1YAPsdj3uqvs=";
    }
    .${system} or throwSystem;
}
