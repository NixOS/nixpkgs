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
  version = "0.4.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1EYYPoS4NJ+jBh8P5/BsqUumW0JpRv/r5uPoKVMyQgw=";
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
    longDescription = ''
      Provides support for parsing, splitting and formatting SQL statements.
    '';
    homepage = "https://github.com/andialbrecht/sqlparse";
    license = licenses.bsd3;
  };
}
