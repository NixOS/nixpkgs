{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.17.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-knblQwO+c8AD0WJ+1l6FJP8j8pdsVhKa/oiPqUJfsVY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-y5OYq1X4Y0DxFYW2CiedcIjhOyeHgMhJ3dMa+2PUCUY=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
