{ stdenv
, buildPythonPackage
, fetchPypi
, python
, wrapPython
, unzip
, callPackage
, bootstrapped-pip
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "41.2.0";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "66b86bbae7cc7ac2e867f52dc08a6bd064d938bac59dfec71b9b565dd36d6012";
  };

  # There is nothing to build
  dontBuild = true;

  nativeBuildInputs = [ bootstrapped-pip ];

  installPhase = ''
      dst=$out/${python.sitePackages}
      mkdir -p $dst
      export PYTHONPATH="$dst:$PYTHONPATH"
      ${python.pythonForBuild.interpreter} setup.py install --prefix=$out
      wrapPythonPrograms
  '';

  # Adds setuptools to nativeBuildInputs causing infinite recursion.
  catchConflicts = false;

  # Requires pytest, causing infinite recursion.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = https://pypi.python.org/pypi/setuptools;
    license = with licenses; [ psfl zpl20 ];
    platforms = python.meta.platforms;
    priority = 10;
  };
}
