{ lib, stdenv, fetchFromGitHub, postgresql, buildPgrxExtension }:

buildPgrxExtension rec {
  pname = "pg_jsonschema";
  version = "unstable-2023-07-23";
  inherit postgresql;

  src = fetchFromGitHub {
    owner  = "supabase";
    repo   = pname;
    rev    = "13044b7e2ce720e13e91130b4ea674783cf4a583";
    hash   = "sha256-SxftRBWBZoDtF7mirKSavUJ/vZbWIC3TKy7L66uwQfc=";
  };

  cargoHash = "sha256-B0gn4DBryB9l27Hi2FMnSZfqwI/pAxCjr3f2t2+m8Og=";

  # FIXME (aseipp): testsuite tries to write files into /nix/store; we'll have
  # to fix this a bit later.
  doCheck = false;

  meta = with lib; {
    description = "JSON Schema Validation for PostgreSQL";
    homepage    = "https://github.com/supabase/${pname}";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.postgresql;
  };
}
