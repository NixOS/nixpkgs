{ stdenv
, fetchPypi
, python
, wrapPython
, unzip
}:

# Should use buildPythonPackage here somehow
stdenv.mkDerivation rec {
  pname = "setuptools";
  version = "40.6.3";
  name = "${python.libPrefix}-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3b474dad69c49f0d2d86696b68105f3a6f195f7ab655af12ef9a9c326d2b08f8";
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
