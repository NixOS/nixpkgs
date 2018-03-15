{ stdenv
, lib
, fetchurl
, buildPythonPackage
, isPy3k, isPy36, pythonOlder
, numpy
, six
, protobuf
, absl-py
, mock
, backports_weakref
, enum34
, tensorflow-tensorboard
, cudaSupport ? false
}:

# tensorflow is built from a downloaded wheel because the source
# build doesn't yet work on Darwin.

buildPythonPackage rec {
  pname = "tensorflow";
  version = "1.5.0";
  format = "wheel";

  src = fetchurl {
    url = "https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-${version}-py3-none-any.whl";
    sha256 = "1mapv45n9wmgcq3i3im0pv0gmhwkxw5z69nsnxb1gfxbj1mz5h9m";
  };

  propagatedBuildInputs = [ numpy six protobuf absl-py ]
                 ++ lib.optional (!isPy3k) mock
                 ++ lib.optionals (pythonOlder "3.4") [ backports_weakref enum34 ]
                 ++ lib.optional (pythonOlder "3.6") tensorflow-tensorboard;

  # tensorflow depends on tensorflow_tensorboard, which cannot be
  # built at the moment (some of its dependencies do not build
  # [htlm5lib9999999 (seven nines) -> tensorboard], and it depends on an old version of
  # bleach) Hence we disable dependency checking for now.
  installFlags = lib.optional isPy36 "--no-dependencies";

  meta = with stdenv.lib; {
    description = "Computation using data flow graphs for scalable machine learning";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp abbradar ];
    platforms = platforms.darwin;
    # Python 2.7 build uses different string encoding.
    # See https://github.com/NixOS/nixpkgs/pull/37044#issuecomment-373452253
    broken = cudaSupport || !isPy3k;
  };
}
