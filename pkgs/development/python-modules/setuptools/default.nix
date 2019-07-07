{ stdenv
, fetchPypi
, python
, wrapPython
, unzip
}:

# Should use buildPythonPackage here somehow
stdenv.mkDerivation rec {
  pname = "setuptools";
  version = "41.0.1";
  name = "${python.libPrefix}-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "a222d126f5471598053c9a77f4b5d4f26eaa1f150ad6e01dcf1a42e185d05613";
  };

  nativeBuildInputs = [ unzip wrapPython python.pythonForBuild ];
  doCheck = false;  # requires pytest
  installPhase = ''
      dst=$out/${python.sitePackages}
      mkdir -p $dst
      export PYTHONPATH="$dst:$PYTHONPATH"
      ${python.pythonForBuild.interpreter} setup.py install --prefix=$out
      wrapPythonPrograms
  '';

  pythonPath = [];

  dontPatchShebangs = true;

  # Python packages built through cross-compilation are always for the host platform.
  disallowedReferences = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ python.pythonForBuild ];


  meta = with stdenv.lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = https://pypi.python.org/pypi/setuptools;
    license = with licenses; [ psfl zpl20 ];
    platforms = python.meta.platforms;
    priority = 10;
  };
}
