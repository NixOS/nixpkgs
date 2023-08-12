{ lib
, buildPythonApplication
, fetchPypi
, python-slugify
, requests
, urllib3
, six
, setuptools
, gitpython
, pythonRelaxDepsHook
}:

buildPythonApplication rec {
  pname = "transifex-client";
  version = "0.14.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11dc95cefe90ebf0cef3749c8c7d85b9d389c05bd0e3389bf117685df562bd5c";
  };

  # https://github.com/transifex/transifex-client/issues/323
  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "python-slugify"
  ];

  propagatedBuildInputs = [
    gitpython
    python-slugify
    requests
    setuptools
    six
    urllib3
  ];

  # Requires external resources
  doCheck = false;

  meta = with lib; {
    description = "Transifex translation service client";
    homepage = "https://www.transifex.com/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sikmir ];
  };
}
