{ lib
, buildPythonPackage
, fetchFromGitHub
, buildBazelPackage
, bazel_5
, python
, absl-py
, setuptools
, wheel
}:

let
  pname = "tensorflow-io";
  version = "0.30.0";
  bazel-wheel = buildBazelPackage {
    name = "${pname}-${version}-py2.py3-none-any.whl";
    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "io";
      rev = "v${version}";
      hash = "sha256-SeXw9MES7tyMQ34jR9NHtO3S+y6nsvU6z0JCjj0r6Mk=";
    };
    postPatch = ''
      # Pins 5.1.1, we've got 5.4.0
      rm -f .bazelversion
    '';

    nativeBuildInputs = [
      setuptools
      wheel
      absl-py
    ];
    bazel = bazel_5;

    # why does it not take a list?
    bazelTarget = "//tensorflow_io/... //tensorflow_io_gcs_filesystem/...";

    fetchAttrs = {
      sha256 = "";
    };

    buildAttrs = {
      preBuild = ''
        patchShebangs .
      '';
      installPhase = ''
        # TODO: cf. tf-probability or something
        # ...
        mv *.whl "$out"
      '';
    };
  };
in
buildPythonPackage {
  inherit pname version;

  src = bazel-wheel;

  meta = with lib; {
    description = "Dataset, streaming, and file system extensions maintained by TensorFlow SIG-IO";
    homepage = "https://www.tensorflow.org/io";
    license = licenses.asl20;
  };
}
