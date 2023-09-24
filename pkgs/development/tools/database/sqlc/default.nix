{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.21.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    rev = "v${version}";
    hash = "sha256-BJKqVSyMjTedMuao8Bz92+B64B/x3M3MXKbSF+d0kDE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-AnPC0x5V8ce9KH0B4Ujz2MrTIJA+P/BZG+fsRJ3LM78=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
