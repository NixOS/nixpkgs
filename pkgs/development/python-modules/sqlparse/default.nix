{ lib
, buildPythonPackage
, fetchPypi
, installShellFiles
, pytestCheckHook
, isPy3k
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.4.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bkx52c2jh28c528b69qfk2ijfzw1laxx6lim7jr8fi6fh67600c";
  };

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ pytestCheckHook ];

  postInstall = ''
    installManPage docs/sqlformat.1
  '';

  meta = with lib; {
    description = "Non-validating SQL parser for Python";
    longDescription = ''
      Provides support for parsing, splitting and formatting SQL statements.
    '';
    homepage = "https://github.com/andialbrecht/sqlparse";
    license = licenses.bsd3;
  };
}
