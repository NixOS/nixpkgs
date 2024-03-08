{ lib
, stdenv
, fetchFromGitHub
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "pg_uuidv7";
  version = "1.4.1";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner = "fboulnois";
    repo = "pg_uuidv7";
    rev = "v${version}";
    hash = "sha256-1qEsDCcULceMqvR3DIC5rOfpzn2PYbFGq0H8p2+9GR4=";
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
