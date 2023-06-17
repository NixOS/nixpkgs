{ lib
, fetchFromGitHub
, buildPgrxExtension
, postgresql
, nix-update-script
}:
let
  version = "1.2.2";
in
buildPgrxExtension rec {
  inherit postgresql version;

  pname = "pg_graphql";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "pg_graphql";
    rev = "v${version}";
    hash = "sha256-SKbUDasdhz/L5UDyMH4gXmFfHHhGx81H90gfIclGwjU=";
  };

  cargoHash = "sha256-wDgxk6xaX0LfnXkGtYLcDMOJZ5yxAHu9Kf+NxswayHk=";

  passthru = {
    updateScript = nix-update-script { };
  };

  # figure out how to do testing properly https://github.com/supabase/pg_graphql/issues/369
  doCheck = false;

  meta = with lib; {
    description = "GraphQL support for PostgreSQL";
    homepage = "https://supabase.github.io/pg_graphql";
    maintainers = with maintainers; [ happysalada ];
    # on darwin: Undefined symbols for architecture x86_64: "_MemoryContextDelete"
    platforms = platforms.linux;
    license = licenses.asl20;

    # this wasn't released before postgres 14 so taking no chances there, but most likely it can be relaxed.
    broken = versionOlder postgresql.version "14";
  };
}
