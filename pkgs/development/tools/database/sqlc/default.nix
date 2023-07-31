{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.19.1";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-xZogHQ44amdhFewovFd1TWrul0wlofUqo46Ay13Mnig=";
  };

  proxyVendor = true;
  vendorHash = "sha256-owH+Gd6K+RzBRhWEs99qQLXV3UWysEkLinEFvzSzXIU=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
