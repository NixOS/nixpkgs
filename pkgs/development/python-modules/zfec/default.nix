{ lib
, buildPythonPackage
, fetchPypi
, pyutil
, setuptoolsTrial
, twisted
}:

buildPythonPackage rec {
  pname = "zfec";
  version = "1.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6033b2f3cc3edacf3f7eeed5f258c1ebf8a1d7e5e35b623db352512ce564e5ca";
  };

  propagatedBuildInputs = [ pyutil ];

  checkInputs = [ setuptoolsTrial twisted ];

  # argparse is in the stdlib but zfec doesn't know that.
  postPatch = ''
    sed -i -e '/argparse/d' setup.py
  '';

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
