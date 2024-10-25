{
  lib,
  anytree,
  arrayqueues,
  av,
  buildPythonPackage,
  colorspacious,
  fetchPypi,
  flammkuchen,
  git,
  gitpython,
  imageio,
  imageio-ffmpeg,
  lightparam,
  matplotlib,
  numba,
  numpy,
  opencv4,
  pandas,
  pims,
  pyqt5,
  pyqtgraph,
  pyserial,
  pytestCheckHook,
  pythonOlder,
  qdarkstyle,
  qimage2ndarray,
  scikit-image,
  scipy,
  tables,
}:

buildPythonPackage rec {
  pname = "stytra";
  version = "0.8.34";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aab9d07575ef599a9c0ae505656e3c03ec753462df3c15742f1f768f2b578f0a";
  };

  patches = [
    # https://github.com/portugueslab/stytra/issues/87
    ./0000-workaround-pyqtgraph.patch
  ];

  propagatedBuildInputs = [
    opencv4
    pyqt5
    pyqtgraph
    numpy
    scipy
    numba
    pandas
    tables
    git
    scikit-image
    matplotlib
    qdarkstyle
    gitpython
    anytree
    qimage2ndarray
    flammkuchen
    pims
    colorspacious
    lightparam
    imageio
    imageio-ffmpeg
    arrayqueues
    av
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyserial
  ];

  disabledTestPaths = [
    # Crashes python
    "stytra/tests/test_z_experiments.py"
  ];

  meta = with lib; {
    description = "Modular package to control stimulation and track behaviour";
    homepage = "https://github.com/portugueslab/stytra";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tbenst ];
  };
}
