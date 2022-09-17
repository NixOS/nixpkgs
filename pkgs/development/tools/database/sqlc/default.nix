{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.15.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-Ufa5A+lsFSyxe7s0DbLhWW298Y1yaSCazMjGBryyMYY=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-KatF4epCzyQCoAGk1verjAYNrFcmcLiVyDI2542Vm3k=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
