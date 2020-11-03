{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k, callPackage
, opencv3
, pyqt5
, pyqtgraph
, numpy
, scipy
, numba
, pandas
, tables
, git
, ffmpeg_3
, scikitimage
, matplotlib
, qdarkstyle
, GitPython
, anytree
, pims
, imageio
, imageio-ffmpeg
, av
, nose
, pytest
, pyserial
, arrayqueues
, colorspacious
, qimage2ndarray
, flammkuchen
, lightparam
}:

buildPythonPackage rec {
  pname = "stytra";
  version = "0.8.34";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "aab9d07575ef599a9c0ae505656e3c03ec753462df3c15742f1f768f2b578f0a";
  };
  doCheck = false;
  checkInputs = [
    nose
    pytest
    pyserial
  ];


  requiredPythonModules = [
    opencv3
    pyqt5
    pyqtgraph
    numpy
    scipy
    numba
    pandas
    tables
    git
    ffmpeg_3
    scikitimage
    matplotlib
    qdarkstyle
    GitPython
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

  meta = {
    homepage = "https://github.com/portugueslab/stytra";
    description = "A modular package to control stimulation and track behaviour";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
