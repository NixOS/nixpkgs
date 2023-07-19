{ lib, buildGoModule, fetchFromGitHub }:

let
  version = "1.19.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "kyleconroy";
    repo = "sqlc";
    rev    = "v${version}";
    sha256 = "sha256-/6CqzkdZMog0ldoMN0PH8QhL1QsOBaDAnqTHlgtHdP8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-AsOm86apA5EiZ9Ss7RPgVn/b2/O6wPj/ur0zG91JoJo=";

  subPackages = [ "cmd/sqlc" ];

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };
}
