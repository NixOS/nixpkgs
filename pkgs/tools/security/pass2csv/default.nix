{ buildPythonApplication
, fetchPypi
, lib
, python-gnupg
, setuptools
}:

buildPythonApplication rec {
  pname = "pass2csv";
  version = "1.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sJX09gyyqCszjypRnJj40BzRl8xW963hSbuGDekxGdA=";
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
    homepage = "https://github.com/reinefjord/pass2csv";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
