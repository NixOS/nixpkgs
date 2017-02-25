{ stdenv, lib, fetchurl, python, wrapPython }:

stdenv.mkDerivation rec {
  pname = "setuptools";
  shortName = "${pname}-${version}";
  name = "${python.libPrefix}-${shortName}";

  version = "30.2.0";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${shortName}.tar.gz";
    sha256 = "f865709919903e3399343c0b3c42f95e9aeddc41e38cfb334fb2bb5dfa384857";
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
