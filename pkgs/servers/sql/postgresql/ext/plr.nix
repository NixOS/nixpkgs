{ lib, stdenv, fetchFromGitHub, pkg-config, R, postgresql, buildPostgresExtension }:

buildPostgresExtension rec {
  pname = "plr";
  version = "8.4.6";

  src = fetchFromGitHub {
    owner = "postgres-plr";
    repo = "plr";
    rev = "REL${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-c+wKWL66pulihVQnhdbzivrZOMD1/FfOpb+vFoHgqVg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ R ];

  makeFlags = [ "USE_PGXS=1" ];

  meta = with lib; {
    description = "PL/R - R Procedural Language for PostgreSQL";
    homepage = "https://github.com/postgres-plr/plr";
    maintainers = with maintainers; [ qoelet ];
    platforms = postgresql.meta.platforms;
    license = licenses.gpl2Only;
  };
}
