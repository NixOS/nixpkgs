{ stdenv, lib, fetchurl, python, wrapPython }:

stdenv.mkDerivation rec {
  shortName = "setuptools-${version}";
  name = "${python.libPrefix}-${shortName}";

  version = "26.1.1";  # 18.4 and up breaks python34Packages.characteristic and many others

  src = fetchurl {
    url = "mirror://pypi/s/setuptools/${shortName}.tar.gz";
    sha256 = "475ce28993d7cb75335942525b9fac79f7431a7f6e8a0079c0f2680641379481";
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

  pythonPath = [];

  meta = with stdenv.lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = http://pypi.python.org/pypi/setuptools;
    license = with lib.licenses; [ psfl zpt20 ];
    platforms = platforms.all;
    priority = 10;
  };
}
