{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, librosa
, numpy
, torch
}:

buildPythonPackage rec {
  pname = "torchlibrosa";
  version = "0.0.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+LzejKvLlJIIwWm9rYPCWQDSueIwnG5gbkwNE+wbv0A=";
  };

  propagatedBuildInputs = [
    librosa
    numpy
    torch
  ];

  patches = [
    # Fix run against librosa 0.9.0, https://github.com/qiuqiangkong/torchlibrosa/pull/8
    (fetchpatch {
      url = "https://github.com/qiuqiangkong/torchlibrosa/commit/eec7e7559a47d0ef0017322aee29a31dad0572d5.patch";
      hash = "sha256-c1x3MA14Plm7+lVuqiuLWgSY6FW615qnKbcWAfbrcas=";
    })
  ];

  # Project has no tests.
  # In order to make pythonImportsCheck work, NUMBA_CACHE_DIR env var need to
  # be set to a writable dir (https://github.com/numba/numba/issues/4032#issuecomment-488102702).
  # pythonImportsCheck has no pre* hook, use checkPhase to workaround that.
  checkPhase = ''
    export NUMBA_CACHE_DIR="$(mktemp -d)"
  '';
  pythonImportsCheck = [ "torchlibrosa" ];

  meta = with lib; {
    description = "PyTorch implemention of part of librosa functions";
    homepage = "https://github.com/qiuqiangkong/torchlibrosa";
    license = licenses.mit;
    maintainers = with maintainers; [ azuwis ];
  };
}
