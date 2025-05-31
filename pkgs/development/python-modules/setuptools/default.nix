{
  stdenv,
  lib,
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  python,
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "80.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools";
    tag = "v${version}";
    hash = "sha256-M65ib9HAbDWisGGpp2NiHwW3yF9fPRbk3vsBm90k1uQ=";
  };

  patches = [
    ./tag-date.patch
  ];

  preBuild = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
  '';

  # Requires pytest, causing infinite recursion.
  doCheck = false;

  passthru.tests = {
    inherit distutils;
  };

  meta = with lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = "https://github.com/pypa/setuptools";
    changelog = "https://setuptools.pypa.io/en/stable/history.html#v${
      replaceStrings [ "." ] [ "-" ] version
    }";
    license = with licenses; [ mit ];
    platforms = python.meta.platforms;
    teams = [ teams.python ];
  };
}
