{ lib
, stdenv
, fetchFromGitHub
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "pg_uuidv7";
  version = "1.3.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner = "fboulnois";
    repo = "pg_uuidv7";
    rev = "v${version}";
    hash = "sha256-kHxS9tL7fpKhjJ8Xx5tee1fv10zVcTt2FgUQSaRdNZo=";
  };

  installPhase = ''
      install -D -t $out/lib pg_uuidv7${postgresql.dlSuffix}
      install -D {sql/pg_uuidv7--${lib.versions.majorMinor version}.sql,pg_uuidv7.control} -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "A tiny Postgres extension to create version 7 UUIDs";
    homepage = "https://github.com/fboulnois/pg_uuidv7";
    changelog = "https://github.com/fboulnois/pg_uuidv7/blob/main/CHANGELOG.md";
    maintainers = with maintainers; [ gaelreyrol ];
    platforms = postgresql.meta.platforms;
    license = licenses.mpl20;
    broken = versionOlder postgresql.version "13";
  };
}
