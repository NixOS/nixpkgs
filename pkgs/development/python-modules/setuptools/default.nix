{ stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, python
, bootstrapped-pip
, lib
, pipInstallHook
, setuptoolsBuildHook
}:

let
  pname = "setuptools";
  version = "63.2.0";

  # Create an sdist of setuptools
  sdist = stdenv.mkDerivation rec {
    name = "${pname}-${version}-sdist.tar.gz";

    src = fetchFromGitHub {
      owner = "pypa";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-GyQjc0XulUxl3Btpj7Q6KHTpd1FDZnXCYviYjjgK7tY=";
      name = "${pname}-${version}-source";
    };

    patches = [
      ./tag-date.patch
      ./setuptools-distutils-C++.patch
      # Fix cross compilation of extension modules
      # https://github.com/pypa/distutils/pull/173
      (fetchpatch {
        url = "https://github.com/pypa/distutils/commit/22b9bcf2e2d2a66f7dc96661312972e2f6bd9e01.patch";
        hash = "sha256-IVb1LLgLIHO6HPn2911uksrLB1jG0MyQetdxkq5wcG4=";
        stripLen = 2;
        extraPrefix = "setuptools/_distutils/";
      })
    ];

    buildPhase = ''
      ${python.pythonForBuild.interpreter} setup.py egg_info
      ${python.pythonForBuild.interpreter} setup.py sdist --formats=gztar

      # Here we untar the sdist and retar it in order to control the timestamps
      # of all the files included
      tar -xzf dist/${pname}-${version}.post0.tar.gz -C dist/
      tar -czf dist/${name} -C dist/ --mtime="@$SOURCE_DATE_EPOCH" --sort=name ${pname}-${version}.post0
    '';

    installPhase = ''
      echo "Moving sdist..."
      mv dist/${name} $out
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

  preBuild = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
  '';

  pipInstallFlags = [ "--ignore-installed" ];

  # Adds setuptools to nativeBuildInputs causing infinite recursion.
  catchConflicts = false;

  # Requires pytest, causing infinite recursion.
  doCheck = false;

  meta = with lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = "https://pypi.python.org/pypi/setuptools";
    license = with licenses; [ psfl zpl20 ];
    platforms = python.meta.platforms;
    priority = 10;
  };
}
