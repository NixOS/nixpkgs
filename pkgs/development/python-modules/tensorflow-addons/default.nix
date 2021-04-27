{ lib
, buildBazelPackage
, buildPythonPackage
, fetchFromGitHub
, python
, rsync
, setuptools
, wheel
, protobuf
, packaging
, tensorflow
, typeguard
, pytestCheckHook
}:

let
  pname = "tensorflow-addons";
  version = "0.16.1";
  format = "setuptools";

  bazel-wheel = buildBazelPackage {
    name = "${pname}-${version}-py2.py3-none-any.whl";

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "addons";
      rev = "v${version}";
      hash = "sha256-/Jds+/+zUX1jgSrCmFrZpAY3bNx0WRwZa0chNAJo9+I=";
    };

    nativeBuildInputs = [
      python
      rsync
      setuptools
      wheel
    ];

    buildInputs = [
      protobuf
    ];

    # https://github.com/tensorflow/addons/blob/master/BUILD
    bazelTarget = ":build_pip_pkg";

    fetchAttrs = {
      sha256 = "sha256-1X00azKc3Me6RM7xkM9CB1aNZF4bBDqKb76NXjht/Wk=";
    };

    TF_CXX11_ABI_FLAG = "0";
    TF_HEADER_DIR = "${tensorflow}/${python.sitePackages}/tensorflow/include/";
    TF_SHARED_LIBRARY_DIR = "${tensorflow}/${python.sitePackages}/tensorflow/";
    TF_SHARED_LIBRARY_NAME = "libtensorflow_framework.so.2";

    buildAttrs = {
      preBuild = ''
        patchShebangs .
      '';

      installPhase = ''
        export SOURCE_DATE_EPOCH=315532800
        ./bazel-bin/build_pip_pkg .
        mv *.whl "$out"
      '';
    };
  };

in buildPythonPackage {
  inherit pname version;
  format = "wheel";

  src = bazel-wheel;

  propagatedBuildInputs = [
    packaging
    tensorflow
    typeguard
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tensorflow_addons/tests"
  ];

  pythonImportsCheck = [
    "tensorflow_addons"
  ];

  meta = with lib; {
    description = "TensorFlow Addons";
    homepage = "https://github.com/tensorflow/addons";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
