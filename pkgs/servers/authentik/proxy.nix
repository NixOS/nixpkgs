{ buildGo118Module, authentik }:

buildGo118Module {
  pname = "authentik-proxy";
  inherit (authentik) version src meta;

  vendorSha256 = "sha256-iCl+grE+utsjh98z22d4u/jIhSLJKVWI5BLGsRmWWxw=";
}
