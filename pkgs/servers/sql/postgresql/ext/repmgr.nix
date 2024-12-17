{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  flex,
  curl,
  json_c,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "repmgr";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "repmgr";
    rev = "v${version}";
    sha256 = "sha256-8G2CzzkWTKEglpUt1Gr7d/DuHJvCIEjsbYDMl3Zt3cs=";
  };

  nativeBuildInputs = [ flex ];

  buildInputs = postgresql.buildInputs ++ [
    curl
    json_c
  ];

  meta = with lib; {
    homepage = "https://repmgr.org/";
    description = "Replication manager for PostgreSQL cluster";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ zimbatm ];
  };
}
