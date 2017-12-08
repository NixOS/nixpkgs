{ stdenv
, fetchPypi
, python
, wrapPython
, unzip
}:

# Should use buildPythonPackage here somehow
stdenv.mkDerivation rec {
  pname = "setuptools";
  version = "38.2.3";
  name = "${python.libPrefix}-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "124jlg72bbk2xxv5wqbwcl4h5cdslslzk92rxjxiplg79l499hv3";
  };

  buildInputs = [ python wrapPython unzip ];
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
    homepage = https://pypi.python.org/pypi/setuptools;
    license = with licenses; [ psfl zpl20 ];
    platforms = platforms.all;
    priority = 10;
  };
}
