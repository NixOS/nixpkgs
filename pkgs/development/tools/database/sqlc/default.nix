{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.22.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    rev = "v${version}";
    hash = "sha256-aSu+d3ti/PpR5oQwciq1Cz+vxDPunGsVaUg/o/rfmsY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-sjGswoIUM+UL6qJORdB3UmPh7T6JmTBI5kksgGcRtY0=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
