{ buildPythonApplication
, fetchPypi
, lib
, python-gnupg
}:

buildPythonApplication rec {
  pname = "pass2csv";
  version = "0.3.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03a11bd0b0905737f4adb21d87aa1653d84cc1d9b5dcfdfb8a29092245d65db8";
  };

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
