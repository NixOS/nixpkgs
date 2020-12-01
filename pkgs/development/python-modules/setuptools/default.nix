{ stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, wrapPython
, unzip
, callPackage
, bootstrapped-pip
, lib
, pipInstallHook
, setuptoolsBuildHook
}:

let
  pname = "setuptools";
  version = "50.3.2";

  # Create an sdist of setuptools
  sdist = stdenv.mkDerivation rec {
    name = "${pname}-${version}-sdist.tar.gz";

    src = fetchFromGitHub {
      owner = "pypa";
      repo = pname;
      rev = "v${version}";
      sha256 = "1cvjmxvf4p7ixcdxky9jdnvr9fab2pbriqr5bpjcgjh6pj1x42ni";
      name = "${pname}-${version}-source";
    };

    patches = [
      ./tag-date.patch
    ];

    buildPhase = ''
      ${python.pythonForBuild.interpreter} bootstrap.py
      ${python.pythonForBuild.interpreter} setup.py sdist --formats=gztar
    '';

    installPhase = ''
      echo "Moving sdist..."
      mv dist/${pname}-${version}.post0.tar.gz $out
    '';
  };
in buildPythonPackage rec {
  inherit pname version;
  # Because of bootstrapping we don't use the setuptoolsBuildHook that comes with format="setuptools" directly.
  # Instead, we override it to remove setuptools to avoid a circular dependency.
  # The same is done for pip and the pipInstallHook.
  format = "other";

  src = sdist;

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
    homepage = "https://pypi.python.org/pypi/setuptools";
    license = with licenses; [ psfl zpl20 ];
    platforms = python.meta.platforms;
    priority = 10;
  };
}
