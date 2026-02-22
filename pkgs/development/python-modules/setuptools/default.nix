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
  version = "80.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools";
    tag = "v${version}";
    hash = "sha256-wueVQsV0ja/iPFRK7OKV27FQ7hYKF8cP3WH5wJeIXnI=";
  };

  patches = [
    ./tag-date.patch
    ./reproducible-wheel.patch
  ];

  # Drop dependency on coherent.license, which in turn requires coherent.build
  postPatch = ''
    sed -i "/coherent.licensed/d" pyproject.toml

    # Substitute version for reproducible builds
    substituteInPlace setuptools/version.py \
      --replace-fail '@version@' '${version}'
  '';

  preBuild = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
  '';

  # Requires pytest, causing infinite recursion.
  doCheck = false;

  passthru.tests = {
    inherit distutils;
  };

  meta = {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = "https://github.com/pypa/setuptools";
    changelog = "https://setuptools.pypa.io/en/stable/history.html#v${
      lib.replaceStrings [ "." ] [ "-" ] version
    }";
    license = with lib.licenses; [ mit ];
    platforms = python.meta.platforms;
    teams = [ lib.teams.python ];
  };
}
