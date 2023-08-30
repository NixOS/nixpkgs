{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.20.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-ITW5jIlNoiW7sl6s5jCVRELglauZzSPmAj3PXVpdIGA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-5ZJPHdjg3QCB/hJ+C7oXSfzBfg0fZ+kFyMXqC7KpJmY=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
