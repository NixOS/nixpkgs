{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

let
  sources = (import ./sources.nix) { inherit fetchFromGitHub; };
in
buildGoModule {
  inherit (sources) pname version src;

  modRoot = "src/hockeypuck/";
  vendorHash = null;
  doCheck = false; # Uses networking for tests

  passthru.tests = nixosTests.hockeypuck;

  meta = with lib; {
    description = "OpenPGP Key Server";
    homepage = "https://github.com/hockeypuck/hockeypuck";
    license = licenses.agpl3Plus;
    maintainers = [ ];
  };
}
