{ lib
, buildPythonPackage
, fetchPypi
, installShellFiles
, pytestCheckHook
, isPy3k
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.4.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-acqASEa7EU0uw4DkNgqKNA24PwzPOvzusUBN8Cj1cmg=";
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
