{ lib, buildGoModule, fetchFromGitHub }:

let
  sources = (import ./sources.nix) { inherit fetchFromGitHub; };
in
buildGoModule {
  inherit (sources) pname version src;

  modRoot = "src/hockeypuck/";
  vendorSha256 = null;
  doCheck = false; # Uses networking for tests

  meta = with lib; {
    description = "OpenPGP Key Server";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.etu ];
  };
}
