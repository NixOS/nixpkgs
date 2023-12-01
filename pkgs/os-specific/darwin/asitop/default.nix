{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "asitop";
  version = "0.0.23";
  format = "setuptools";

  disabled = python3.pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BNncgQRNAd6Pgur5D1xVQi3LSsijSAYIYvhsuiVyi9Q=";
  };

  # has no tests
  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
    dashing
    psutil
  ];

  meta = with lib; {
    homepage = "https://github.com/tlkh/asitop";
    description = "Perf monitoring CLI tool for Apple Silicon";
    platforms = platforms.darwin;
    license = licenses.mit;
    maintainers = with maintainers; [ juliusrickert ];
  };
}
