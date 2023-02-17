{ lib
, anytree
, arrayqueues
, av
, buildPythonPackage
, colorspacious
, fetchPypi
, flammkuchen
, git
, gitpython
, imageio
, imageio-ffmpeg
, lightparam
, matplotlib
, nose
, numba
, numpy
, opencv3
, pandas
, pims
, pyqt5
, pyqtgraph
, pyserial
, pytestCheckHook
, pythonOlder
, qdarkstyle
, qimage2ndarray
, scikitimage
, scipy
, tables
}:

buildPythonPackage rec {
  pname = "stytra";
  version = "0.8.34";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aab9d07575ef599a9c0ae505656e3c03ec753462df3c15742f1f768f2b578f0a";
  };

  # crashes python
  preCheck = ''
    rm stytra/tests/test_z_experiments.py
  '';

  propagatedBuildInputs = [
    opencv3
    pyqt5
    pyqtgraph
    numpy
    scipy
    numba
    pandas
    tables
    git
    scikitimage
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
    nose
    pytestCheckHook
    pyserial
  ];

  meta = with lib; {
    description = "A modular package to control stimulation and track behaviour";
    homepage = "https://github.com/portugueslab/stytra";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tbenst ];
  };
}
