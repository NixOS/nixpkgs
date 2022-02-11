{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, numpy
, wheel
, werkzeug
, protobuf
, grpcio
, markdown
, absl-py
, google-auth-oauthlib
, setuptools
, tensorboard-data-server
, tensorboard-plugin-wit
, tensorboard-plugin-profile
}:

# tensorflow/tensorboard is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719 blocks
# buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "2.6.0";
  format = "wheel";
  disabled = pythonOlder "3.6" || pythonAtLeast "3.10";

  src = fetchPypi {
    pname = "tensorboard";
    inherit version format;
    dist = "py3";
    python = "py3";
    sha256 = "sha256-99rEzftS0UyeP3RYXOKq+OYgNiCoZOUfr4SYiwn3u9s=";
  };

  postPatch = ''
    chmod u+rwx -R ./dist
    pushd dist
    wheel unpack --dest unpacked ./*.whl
    pushd unpacked/tensorboard-${version}

    substituteInPlace tensorboard-${version}.dist-info/METADATA \
      --replace "google-auth (<2,>=1.6.3)" "google-auth (<3,>=1.6.3)"

    popd
    wheel pack ./unpacked/tensorboard-${version}
    popd
  '';

  propagatedBuildInputs = [
    absl-py
    grpcio
    google-auth-oauthlib
    markdown
    numpy
    protobuf
    setuptools
    tensorboard-data-server
    tensorboard-plugin-profile
    tensorboard-plugin-wit
    werkzeug
    # not declared in install_requires, but used at runtime
    # https://github.com/NixOS/nixpkgs/issues/73840
    wheel
  ];

  # in the absence of a real test suite, run cli and imports
  checkPhase = ''
    $out/bin/tensorboard --help > /dev/null
  '';

  pythonImportsCheck = [
    "tensorboard"
    "tensorboard.backend"
    "tensorboard.compat"
    "tensorboard.data"
    "tensorboard.plugins"
    "tensorboard.summary"
    "tensorboard.util"
  ];

  meta = with lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = "https://www.tensorflow.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
