{ lib
, buildPythonPackage
, fetchPypi
, pyutil
, twisted
}:

buildPythonPackage rec {
  pname = "zfec";
  version = "1.5.7.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TuUZvg3MfaLohIK8/Av5d6Ql4dfoJ4z1u7uNAPiir7Y=";
  };

  propagatedBuildInputs = [ pyutil ];

  nativeCheckInputs = [ twisted ];

  checkPhase = "trial zfec";

  pythonImportsCheck = [ "zfec" ];

  meta = with lib; {
    homepage = "https://github.com/tahoe-lafs/zfec";
    description = "Zfec, a fast erasure codec which can be used with the command-line, C, Python, or Haskell";
    longDescription = ''
      Fast, portable, programmable erasure coding a.k.a. "forward
      error correction": the generation of redundant blocks of
      information such that if some blocks are lost then the
      original data can be recovered from the remaining blocks. The
      zfec package includes command-line tools, C API, Python API,
      and Haskell API.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ prusnak ];
  };

}
