{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.24.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    rev = "v${version}";
    hash = "sha256-j+pyj1CJw0L3s4Nyhy+XXUgX2wbrOWveEJQ4cFhQEvs=";
  };

  proxyVendor = true;
  vendorHash = "sha256-xOMqZCuENGuCs+VkbCxMpXOEr4MALhlveTfUHEPnP1w=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
