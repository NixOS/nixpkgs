{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.17.2";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-30dIFo07C+noWdnq2sL1pEQZzTR4FfaV0FvyW4BxCU8=";
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
