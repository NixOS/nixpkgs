{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  wheel,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "setuptools";
  version = "70.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools";
    rev = "refs/tags/v${version}";
    hash = "sha256-LXF3R9zfWylvihP2M8N94/IlgifwxUwKJFhtvcXEPB0=";
  };

  patches = [
    ./tag-date.patch
    ./setuptools-distutils-C++.patch
    (fetchpatch {
      # PR: https://github.com/pypa/setuptools/pull/4484
      # Fix error, ModuleNotFoundError: No module named 'distutils', for function byte_compile
      name = "fix-byte-complie.patch";
      url = "https://patch-diff.githubusercontent.com/raw/pypa/setuptools/pull/4484.patch";
      sha256 = "sha256-gVE/D/w8cTRh2GMFDs6XeNprtpVitMNNmgo0e0Zz33k=";
    })
  ];

  nativeBuildInputs = [ wheel ];

  preBuild = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
  '';

  # Requires pytest, causing infinite recursion.
  doCheck = false;

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
