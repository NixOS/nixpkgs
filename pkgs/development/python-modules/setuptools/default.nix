{
  stdenv,
  lib,
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  python,
  wheel,
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "75.8.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools";
    tag = "v${version}";
    hash = "sha256-nD6c2JOjBL/SfgNchBlNasuwnrRl6XIuppjOt6Hr7CE=";
  };

  patches = [
    ./tag-date.patch
  ];

  nativeBuildInputs = [ wheel ];

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
    maintainers = teams.python.members;
  };
}
