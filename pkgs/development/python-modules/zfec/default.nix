{ stdenv
, buildPythonPackage
, fetchPypi
, setuptoolsDarcs
, pyutil
, argparse
, isPyPy
}:

buildPythonPackage rec {
  pname = "zfec";
  version = "1.4.24";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ks94zlpy7n8sb8380gf90gx85qy0p9073wi1wngg6mccxp9xsg3";
  };

  buildInputs = [ setuptoolsDarcs ];
  propagatedBuildInputs = [ pyutil argparse ];

  meta = with stdenv.lib; {
    homepage = http://allmydata.org/trac/zfec;
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
