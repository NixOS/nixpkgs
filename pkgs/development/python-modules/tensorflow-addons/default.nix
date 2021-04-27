{ lib
, buildBazelPackage
, buildPythonPackage
, fetchFromGitHub
, python
, rsync
, setuptools
, wheel
, tensorflow
, typeguard
, pytestCheckHook
}:

let
  pname = "tensorflow-addons";
  version = "0.13.0";

  bazel-wheel = buildBazelPackage {
    name = "${pname}-${version}-py2.py3-none-any.whl";

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "addons";
      rev = "v${version}";
      sha256 = "1568cs2z6vdiidcddza443n5f8injv1z01an6adp1q68xqhs65pd";
    };

    nativeBuildInputs = [
      python
      rsync
      setuptools
      wheel
    ];

    # https://github.com/tensorflow/addons/blob/master/BUILD
    bazelTarget = ":build_pip_pkg";

    fetchAttrs = {
      sha256 = "0sgxdlw5x3dydy53l10vbrj8smh78b7r1wff8jxcgp4w69mk8zfm";
    };

    TF_CXX11_ABI_FLAG = "0";
    TF_HEADER_DIR = "${tensorflow.out}/lib/python3.8/site-packages/tensorflow/include/";
    TF_SHARED_LIBRARY_DIR = "${tensorflow.out}/lib/python3.8/site-packages/tensorflow/";
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
