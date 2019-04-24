{ stdenv
, fetchPypi
, python
, wrapPython
, unzip
}:

# Should use buildPythonPackage here somehow
stdenv.mkDerivation rec {
  pname = "setuptools";
  version = "41.0.0";
  name = "${python.libPrefix}-${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "79d30254b6fe7a8e672e43cd85f13a9f3f2a50080bc81d851143e2219ef0dcb1";
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
