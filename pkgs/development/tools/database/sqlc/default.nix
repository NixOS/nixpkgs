{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.18.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-5MC7D9+33x/l76j186FCnzo0Hnx0wY6BPdneW7E7MpE=";
  };

  proxyVendor = true;
  vendorHash = "sha256-gDePB+IZSyVIILDAj+O0Q8hgL0N/0Mwp1Xsrlh3B914=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
