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
, ffmpeg
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
  version = "0.8.27";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fc1ca5f75f47ec1eeb3d62722437bed4ddf598e130b3dd22f0e663f61857df5";
  };
  doCheck = false;
  checkInputs = [
    nose
    pytest
    pyserial
  ];


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
    ffmpeg
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
