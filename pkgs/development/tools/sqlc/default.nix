{ lib, buildGoModule, fetchurl, unzip, postgresql, libpg_query }:

let
  pg_query_go = fetchurl {
    url =
      "https://github.com/pganalyze/pg_query_go/archive/refs/tags/v2.1.0.zip";
    sha256 = "sha256:0hyfbpgc0qs86qsn5sl7f8lzhhjh8h7y5nwd0p3ha4xwppafqs12";
  };

in buildGoModule rec {
  pname = "sqlc";
  version = "1.13.0";

  src = fetchurl {
    url =
      "https://github.com/kyleconroy/sqlc/archive/refs/tags/v${version}.zip";
    sha256 = "sha256:1f044fv4ibh9wzk8f9hkyi96kqaqxhxh54jkaicy8qavx13d82ds";
  };

  vendorSha256 = "sha256:0ahxm7i6rd6qj9qpbnh4bwba8wscwjwgkn6xi45lkqr9k2l09zql";
  proxyVendor = true;
  nativeBuildInputs = [ libpg_query postgresql unzip ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  subPackages = [ "cmd/sqlc" ];

  meta = with lib; {
    description = "sqlc generates fully type-safe idiomatic code from SQL";
    homepage = "https://sqlc.dev";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ luisnquin ];
  };
}
