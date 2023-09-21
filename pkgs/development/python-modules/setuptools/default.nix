{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, python
, wheel
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "68.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ew/DpI5XsYMB4kBfkFeeB5wv5cjx4oYTddZCWLgBHBs=";
  };

  patches = [
    ./tag-date.patch
    ./setuptools-distutils-C++.patch
  ];

  nativeBuildInputs = [
    wheel
  ];

  preBuild = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
  '';

  # Requires pytest, causing infinite recursion.
  doCheck = false;

  meta = with lib; {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = "https://github.com/pypa/setuptools";
    changelog = "https://setuptools.pypa.io/en/stable/history.html#v${replaceStrings [ "." ] [ "-" ] version}";
    license = with licenses; [ mit ];
    platforms = python.meta.platforms;
    maintainers = teams.python.members;
  };
}
