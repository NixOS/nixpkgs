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
  version = "0.8.33";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0aacc8e2c1bba33c337ebc76c0d8f2971c113d298aea2a375d84a5eeff5d83e";
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
