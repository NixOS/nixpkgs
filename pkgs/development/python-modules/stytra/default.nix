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
}:

buildPythonPackage rec {
  pname = "stytra";
  version = "0.8.26";
  disabled = !isPy3k;

  arrayqueues = callPackage ./arrayqueues.nix {};
  colorspacious = callPackage ./colorspacious.nix {};
  qimage2ndarray = callPackage ./qimage2ndarray.nix {};
  flammkuchen = callPackage ./flammkuchen.nix {};
  lightparam = callPackage ./lightparam.nix {};

  src = fetchPypi {
    inherit pname version;
    sha256 = "81842a957e3114230c2d628f64325cd89d166913b68c3f802c89282f40918587";
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
    maintainer = with lib.maintainers; [ tbenst ];
  };
}
