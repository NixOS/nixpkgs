{ lib
, buildPythonPackage
, cloudpickle
, fetchPypi
, ipykernel
, ipython
, jupyter-client
, packaging
, pythonOlder
, pyxdg
, pyzmq
, wurlitzer
}:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "2.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0aNkq4nacW2RZxup2J748ZZgaLug5HB5ekiWU4KcqvM=";
  };

  propagatedBuildInputs = [
    cloudpickle
    ipykernel
    ipython
    jupyter-client
    packaging
    pyxdg
    pyzmq
    wurlitzer
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ipykernel>=6.16.1,<7" "ipykernel" \
      --replace "ipython>=7.31.1,<8" "ipython"
  '';

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "spyder_kernels"
  ];

  meta = with lib; {
    description = "Jupyter kernels for Spyder's console";
    homepage = "https://docs.spyder-ide.org/current/ipythonconsole.html";
    downloadPage = "https://github.com/spyder-ide/spyder-kernels/releases";
    changelog = "https://github.com/spyder-ide/spyder-kernels/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
