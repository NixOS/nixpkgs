{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.13.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-HPCt47tctVV8Oz9/7AoVMezIAv6wEsaB7B4rgo9/fNU=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-miyNIF6RNOuvNEA9Hf+hOyRJG+5IcXU4Vo4Fzn+nIb4=";

  subPackages = [ "cmd/sqlc" ];

  meta = with lib; {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = licenses.mit;
    maintainers = [ maintainers.adisbladis ];
  };
}
