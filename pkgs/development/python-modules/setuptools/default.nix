{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, python
, wheel
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "68.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools";
    rev = "refs/tags/v${version}";
    hash = "sha256-PpZbITlYp/cA+8jmObw8g69TK+oE9YEXD3NNJixExB4=";
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
