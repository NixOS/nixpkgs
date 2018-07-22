{ stdenv
, fetchPypi
, python
, wrapPython
, unzip
}:

# Should use buildPythonPackage here somehow
stdenv.mkDerivation rec {
  pname = "setuptools";
  version = "40.0.0";
  name = "${python.libPrefix}-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "012adb8e25fbfd64c652e99e7bab58799a3aaf05d39ab38561f69190a909015f";
  };

  nativeBuildInputs = [ unzip wrapPython ];
  buildInputs = [ python ];
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
    platforms = python.meta.platforms;
    priority = 10;
  };
}
