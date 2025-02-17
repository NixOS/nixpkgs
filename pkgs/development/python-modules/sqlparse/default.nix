{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  installShellFiles,
  pytestCheckHook,
  pythonOlder,

  # for passthru.tests
  django,
  django_4,
  django-silk,
  pgadmin4,
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CfZ3h/VqCxbs294b/H9dnDNxymg8/qqOb/YLSAfsknI=";
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

  meta = with lib; {
    description = "Non-validating SQL parser for Python";
    longDescription = ''
      Provides support for parsing, splitting and formatting SQL statements.
    '';
    homepage = "https://github.com/andialbrecht/sqlparse";
    changelog = "https://github.com/andialbrecht/sqlparse/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    mainProgram = "sqlformat";
  };
}
