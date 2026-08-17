{
  stdenv,
  lib,
  buildPythonPackage,
  distutils_80,
  fetchFromGitHub,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "setuptools";
  version = "80.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "setuptools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kf2c4auQrZDGW8bM0SxOPFsR8IE4b0coevTxKWGtHp8=";
  };

  patches = [
    ./reproducible-wheel.patch
  ];

  # Drop dependency on coherent.license, which in turn requires coherent.build
  postPatch = ''
    sed -i "/coherent.licensed/d" pyproject.toml

    # Substitute version for reproducible builds
    substituteInPlace setuptools/version.py \
      --replace-fail '@version@' '${finalAttrs.version}'
  '';

  preBuild = lib.optionalString (!stdenv.hostPlatform.isWindows) ''
    export SETUPTOOLS_INSTALL_WINDOWS_SPECIFIC_FILES=0
  '';

  # Requires pytest, causing infinite recursion.
  doCheck = false;

  passthru.tests = {
    inherit distutils_80;
  };

  meta = {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = "https://github.com/pypa/setuptools";
    changelog = "https://setuptools.pypa.io/en/stable/history.html#v${
      lib.replaceString "." "-" finalAttrs.version
    }";
    license = with lib.licenses; [ mit ];
    platforms = python.meta.platforms;
    teams = [ lib.teams.python ];
  };
})
