{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pg8000,
  postgresql,
  psycopg2,
  pytestCheckHook,
  pythonOlder,
  sqlalchemy,
  testing-common-database,
}:

buildPythonPackage rec {
  pname = "testing-postgresql";
  # Version 1.3.0 isn't working so let's use the latest commit from GitHub
  version = "unstable-2017-10-31";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tk0miya";
    repo = "testing.postgresql";
    rev = "c81ded434d00ec8424de0f9e1f4063c778c6aaa8";
    hash = "sha256-A4tahAaa98X66ZYa3QxIQDZkwAwVB6ZDRObEhkbUWKs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    testing-common-database
    pg8000
  ];

  nativeCheckInputs = [
    pytestCheckHook
    psycopg2
    sqlalchemy
  ];

  # Add PostgreSQL to search path
  prePatch = ''
    substituteInPlace src/testing/postgresql.py \
      --replace-fail "/usr/local/pgsql" "${postgresql}"
  '';

  pythonRelaxDeps = [ "pg8000" ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pg8000 >= 1.10" "pg8000"
    substituteInPlace tests/test_postgresql.py \
      --replace-fail "self.assertRegexpMatches" "self.assertRegex"
  '';

  pythonImportsCheck = [ "testing.postgresql" ];

  # Fix tests for Darwin build. See:
  # https://github.com/NixOS/nixpkgs/pull/74716#issuecomment-598546916
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Use temporary postgresql instance in testing";
    homepage = "https://github.com/tk0miya/testing.postgresql";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
