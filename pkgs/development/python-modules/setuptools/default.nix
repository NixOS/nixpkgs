{ stdenv, lib, fetchurl, python, wrapPython }:

stdenv.mkDerivation rec {
  pname = "setuptools";
  shortName = "${pname}-${version}";
  name = "${python.libPrefix}-${shortName}";

  version = "28.8.0";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${shortName}.tar.gz";
    sha256 = "432a1ad4044338c34c2d09b0ff75d509b9849df8cf329f4c1c7706d9c2ba3c61";
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
