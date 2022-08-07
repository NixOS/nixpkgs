{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.14.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-+JkNuN5Hv1g1+UpJEBZpf7QV/3A85IVzMa5cfeRSQRo=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-QG/pIsK8krBaO5IDgln10jpCnlw3XC8sIYyzuwYjTs0=";

  subPackages = [ "cmd/sqlc" ];

  meta = with lib; {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = licenses.mit;
    maintainers = [ maintainers.adisbladis ];
  };
}
