{ buildPythonApplication
, fetchPypi
, lib
, python-gnupg
, setuptools
}:

buildPythonApplication rec {
  pname = "pass2csv";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p7r+zDakKy/N+RbxAfGatvkYCDKRh5T3owoYUrHJ5N0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    python-gnupg
  ];

  # Project has no tests.
  doCheck = false;

  meta = with lib; {
    description = "Export pass(1), \"the standard unix password manager\", to CSV";
    mainProgram = "pass2csv";
    homepage = "https://github.com/reinefjord/pass2csv";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
