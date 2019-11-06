{ lib, buildPythonPackage, setuptools_scm, fetchFromGitHub, isPy3k
, fetchurl
, numpy
, bash
, six
, termcolor
, tabulate
, tqdm
, lmdb
, msgpack
, pkgs
, msgpack-numpy
, pyzmq
, psutil
, scikitimage
, flake8
, tensorflow
, opencv3
}:

buildPythonPackage rec {
  pname = "tensorpack";
  version = "0.10";
  disabled=!isPy3k;

  src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      sha256 = "046nj1y8rl0zsp6q2x7vbhnphq21xbyyjpndi8f2rv9hx9nbxyjv";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [
    numpy
    opencv3
    six
    termcolor
    tabulate
    tqdm
    lmdb
    msgpack
    msgpack-numpy
    pyzmq
    psutil
  ];
  
  checkInputs = [
    scikitimage
    flake8
    tensorflow
  ];

  checkPhase = ''
    mkdir mnist_data
    export TENSORPACK_DATASET="$(pwd)"
    ln -s ${pkgs.mnist}/* mnist_data/
    bash tests/run-tests.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/tensorpack/tensorpack";
    maintainers = with maintainers; [ tbenst ];
    description = "A neural network training interface based on TensorFlow";
    license = licenses.asl20;
  };
}
