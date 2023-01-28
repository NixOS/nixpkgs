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
    postPatch =
      let
        rulesPython.oldRef = "aa96a691d3a8177f3215b14b0edc9641787abaaa30363a080165d06ab65e1161";
        # Cf. https://github.com/bazelbuild/rules_python/blob/82c8f0a084c35dafc381725c195597910cbab218/.github/workflows/workspace_snippet.sh#L9
        rulesPython.newRef = "8c15896f6686beb5c631a4459a3aa8392daccaab805ea899c9d14215074b60ef";
        rulesPython.oldUrl = "https://github.com/bazelbuild/rules_python/releases/download/0.0.1/rules_python-0.0.1.tar.gz";
        rulesPython.newUrl = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.17.3.tar.gz";
        rulesPython.insertAfter = ''name = "rules_python"'';
        rulesPython.insertStripPrefix = ''strip_prefix = "rules_python-0.17.3",'';
      in
      ''
        # Pins 5.1.1, we've got 5.4.0
        rm -f .bazelversion

        substituteInPlace WORKSPACE \
          --replace "${rulesPython.oldRef}" "${rulesPython.newRef}" \
          --replace "${rulesPython.oldUrl}" "${rulesPython.newUrl}"
        sed -i '/${rulesPython.insertAfter}/a ${rulesPython.insertStripPrefix}' WORKSPACE 
        sed -i 's/^.*rules_python-0.0.1.*$//' WORKSPACE
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
