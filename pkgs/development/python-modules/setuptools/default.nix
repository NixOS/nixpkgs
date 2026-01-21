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
  version = "80.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools";
    tag = "v${version}";
    hash = "sha256-s/gfJc3yxvCE6cjP03vtIZqNFmoZKR3d7+4gTPk1hQg=";
  };

  # Drop dependency on coherent.license, which in turn requires coherent.build
  postPatch = ''
    sed -i "/coherent.licensed/d" pyproject.toml
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
