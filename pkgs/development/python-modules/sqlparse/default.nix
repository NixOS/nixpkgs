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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Non-validating SQL parser for Python";
    longDescription = ''
      Provides support for parsing, splitting and formatting SQL statements.
    '';
    homepage = "https://github.com/andialbrecht/sqlparse";
    changelog = "https://github.com/andialbrecht/sqlparse/blob/${version}/CHANGELOG";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
=======
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "sqlformat";
  };
}
