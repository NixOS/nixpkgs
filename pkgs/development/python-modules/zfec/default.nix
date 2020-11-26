{ stdenv
, buildPythonPackage
, fetchPypi
, setuptoolsDarcs
, pyutil
}:

buildPythonPackage rec {
  pname = "zfec";
  version = "1.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "222a2d84898db792b28f993cb663e940668bfbd844992a82351fd40dc1680883";
  };

  buildInputs = [ setuptoolsDarcs ];
  propagatedBuildInputs = [ pyutil ];

  # argparse is in the stdlib but zfec doesn't know that.
  postPatch = ''
    sed -i -e '/argparse/d' setup.py
  '';

  meta = with stdenv.lib; {
    homepage = "http://allmydata.org/trac/zfec";
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
  };

}
