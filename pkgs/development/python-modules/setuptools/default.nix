{ stdenv
, buildPythonPackage
, fetchPypi
, python
, wrapPython
, unzip
, callPackage
, bootstrapped-pip
, lib
, pipInstallHook
, setuptoolsBuildHook
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "41.2.0";
  # Because of bootstrapping we don't use the setuptoolsBuildHook that comes with format="setuptools" directly.
  # Instead, we override it to remove setuptools to avoid a circular dependency.
  # The same is done for pip and the pipInstallHook.
  format = "other";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "66b86bbae7cc7ac2e867f52dc08a6bd064d938bac59dfec71b9b565dd36d6012";
  };

  nativeBuildInputs = [
    bootstrapped-pip
    (pipInstallHook.override{pip=null;})
    (setuptoolsBuildHook.override{setuptools=null; wheel=null;})
  ];

  preBuild = lib.strings.optionalString (!stdenv.hostPlatform.isWindows) ''
    export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
  '';

  pipInstallFlags = [ "--ignore-installed" ];

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
