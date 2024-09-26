{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonRelaxDepsHook,
  pgvector,
  sqlalchemy,
  psycopg2,
  flupy,
  deprecated,
}:

buildPythonPackage rec {
  pname = "vecs";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CmApQUOuxDvQNEu5I1tuV/j5GdECU49rmJ17hQlaMc4=";
  };

  build-system = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    # psycopg can be used from source rather than binary
    "psycopg2-binary"
  ];

  dependencies = [
    pgvector
    sqlalchemy
    psycopg2
    flupy
    deprecated
  ];

  meta = with lib; {
    broken = (versionAtLeast pgvector.version "0.2.0");
    description = "Postgres/pgvector Python Client";
    homepage = "https://supabase.github.io/vecs/latest";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.viraptor ];
  };
}
