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
    sha256 = "0c00730c74263a94e5a9919ade150dfc3b19c574389985446148402998287dae";
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
