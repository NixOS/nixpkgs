{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "martin";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "martin";
    rev = "v${version}";
    hash = "sha256-gMIdUqX872TMAS8tyLoKJVWBBAphikhz/s6P+vbZSCw=";
  };

  cargoHash = "sha256-Jt5e4ULLIEta0QwvAkHRx891tMUhbj4eAvnPOXAb9CM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  checkFlags = [
    "--skip function_source_schemas"
    "--skip function_source_tile"
    "--skip function_source_tilejson"
    "--skip pg_get_function_tiles"
    "--skip pg_get_function_source_ok_rewrite"
    "--skip pg_get_function_source_ok"
    "--skip pg_get_composite_source_tile_minmax_zoom_ok"
    "--skip pg_get_function_source_query_params_ok"
    "--skip pg_get_composite_source_tile_ok"
    "--skip pg_get_catalog"
    "--skip pg_get_composite_source_ok"
    "--skip pg_get_health_returns_ok"
    "--skip pg_get_table_source_ok"
    "--skip pg_get_table_source_rewrite"
    "--skip pg_null_functions"
    "--skip utils::test_utils::tests::test_bad_os_str"
    "--skip utils::test_utils::tests::test_get_env_str"
    "--skip pg_get_table_source_multiple_geom_tile_ok"
    "--skip pg_get_table_source_tile_minmax_zoom_ok"
    "--skip pg_tables_feature_id"
    "--skip pg_get_table_source_tile_ok"
    "--skip table_source_schemas"
    "--skip tables_srid_ok"
    "--skip tables_tile_ok"
    "--skip table_source"
    "--skip tables_tilejson"
    "--skip tables_multiple_geom_ok"
  ];

  meta = with lib; {
    description = "Blazing fast and lightweight PostGIS vector tiles server";
    homepage = "https://martin.maplibre.org/";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ sikmir ];
  };
}
