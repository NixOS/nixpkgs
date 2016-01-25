{ stdenv, lib, fetchurl, python, wrapPython }:

stdenv.mkDerivation rec {
  shortName = "setuptools-${version}";
  name = "${python.executable}-${shortName}";

  version = "20.0";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${shortName}.tar.gz";
    sha256 = "a6f7b295f399fed3de918c4bea9e2053a5fbd9e3a55a6fef7aafe9d1f474866d";
  };

  buildInputs = [ python wrapPython ];
  doCheck = false;  # requires pytest
  installPhase = ''
      dst=$out/${python.sitePackages}
      mkdir -p $dst
      export PYTHONPATH="$dst:$PYTHONPATH"
      ${python.interpreter} setup.py install --prefix=$out
      wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = http://pypi.python.org/pypi/setuptools;
    license = with lib.licenses; [ psfl zpt20 ];
    platforms = platforms.all;
  };
}
