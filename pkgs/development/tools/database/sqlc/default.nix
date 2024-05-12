{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.26.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    rev = "v${version}";
    hash = "sha256-o23FQytw+zpkmTTxxxunHx3NvLF5q0ZSl1NV+D+XKww=";
  };

  proxyVendor = true;
  vendorHash = "sha256-T4DUuZg1yVxSgw/SXgajpvYwzfYZYxzLE3F7U9bpUTw=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    mainProgram = "sqlc";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
