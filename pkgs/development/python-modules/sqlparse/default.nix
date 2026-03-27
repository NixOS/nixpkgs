{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  installShellFiles,
  pytestCheckHook,

  # for passthru.tests
  django,
  django_4,
  django-silk,
  pgadmin4,
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.5.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4g1KmwuFhf32OxDTAGbHyUxden7EfIiaLYOjyqk/8o4=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ pytestCheckHook ];

  postInstall = ''
    installManPage docs/sqlformat.1
  '';

  passthru.tests = {
    inherit
      django
      django_4
      django-silk
      pgadmin4
      ;
  };

  meta = {
    description = "Non-validating SQL parser for Python";
    longDescription = ''
      Provides support for parsing, splitting and formatting SQL statements.
    '';
    homepage = "https://github.com/andialbrecht/sqlparse";
    changelog = "https://github.com/andialbrecht/sqlparse/blob/${version}/CHANGELOG";
    license = lib.licenses.bsd3;
    mainProgram = "sqlformat";
  };
}
