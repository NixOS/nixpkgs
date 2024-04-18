{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, installShellFiles
, pytestCheckHook
, isPy3k

# for passthru.tests
, django
, django_4
, django-silk
, pgadmin4
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.5.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cU0KSTLAWdFhifWO9UEewih6Q2DxfN0O3S0J1MUIfJM=";
  };

  format = "pyproject";

  nativeBuildInputs = [ flit-core installShellFiles ];

  nativeCheckInputs = [ pytestCheckHook ];

  postInstall = ''
    installManPage docs/sqlformat.1
  '';

  passthru.tests = {
    inherit django django_4 django-silk pgadmin4;
  };

  meta = with lib; {
    description = "Non-validating SQL parser for Python";
    mainProgram = "sqlformat";
    longDescription = ''
      Provides support for parsing, splitting and formatting SQL statements.
    '';
    homepage = "https://github.com/andialbrecht/sqlparse";
    license = licenses.bsd3;
  };
}
