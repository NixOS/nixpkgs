{ lib
, buildPythonPackage
, fetchPypi
, installShellFiles
, pytestCheckHook
, isPy3k
}:

buildPythonPackage rec {
  pname = "sqlparse";
  version = "0.4.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f91fd2e829c44362cbcfab3e9ae12e22badaa8a29ad5ff599f9ec109f0454e8";
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
