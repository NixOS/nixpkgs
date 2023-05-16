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
<<<<<<< HEAD
  version = "2.4.4";
=======
  version = "2.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-NjuwoOFZTLaRY3RkGS9PGZaQlUaSUiQrQ8CSvzBaJd0=";
=======
    hash = "sha256-0aNkq4nacW2RZxup2J748ZZgaLug5HB5ekiWU4KcqvM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
