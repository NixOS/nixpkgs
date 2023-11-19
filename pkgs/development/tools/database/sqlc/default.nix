{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.23.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    rev = "v${version}";
    hash = "sha256-MM4O/njW4R1darZMtoevuLMt14/BrCAaFvSX06CTso8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-tJ+Bih+vwkYfEvIsJ6R2Z0eDS9m1eTOS68uyad0F6f0=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
