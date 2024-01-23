{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.25.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    rev = "v${version}";
    hash = "sha256-VrR/oSGyKtbKHfQaiLQ9oKyWC1Y7lTZO1aUSS5bCkKY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-C5OOTAYoSt4anz1B/NGDHY5NhxfyTZ6EHis04LFnMPM=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
