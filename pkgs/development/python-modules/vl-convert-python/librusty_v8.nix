{
  lib,
  stdenv,
  fetchurl,
}:

let
  fetch_librusty_v8 =
    args:
    fetchurl {
      name = "librusty_v8-${args.version}";
      url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
      sha256 =
        args.shas.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      meta = {
        inherit (args) version;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    };
in
fetch_librusty_v8 {
  version = "0.105.1";
  shas = {
    x86_64-linux = "sha256-f7aDA74Jn2h4rp9sACGHX4DBbN6yevgWCEKdfI1fJDU=";
    aarch64-linux = "sha256-vuEP7in+A/PrBXSunRq1SC77dOuMiScsKcA712AuNuk=";
    x86_64-darwin = "sha256-sNe2VCwZvy64jdbPwx7pZ91fFRv1xosOcGiAtSPbt8A=";
    aarch64-darwin = "sha256-GmwTJADMxArwOvRN/w5KVmWGc1+WfraBc/wWe7dxHMg=";
  };
}
