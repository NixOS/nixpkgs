{ buildPythonApplication
, fetchPypi
, lib
, python-gnupg
}:

buildPythonApplication rec {
  pname = "pass2csv";
  version = "0.3.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qY094A5F7W2exGcsS9AJuO5RrBcAn0cCrJquOc6zGZM=";
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
