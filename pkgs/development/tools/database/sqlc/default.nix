{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.16.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-YxGMfGhcPT3Pcyxu1hAkadkJnEBMX26fE/rGfGSTsyc=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-cMYTQ8rATCXOquSxc4iZ2MvxIaMO3RG8PZkpOwwntyc=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
