{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  meson-python,
  versioningit,
  pkg-config,
  nix-update-script,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uarray";
  version = "0.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "uarray";
    tag = version;
    hash = "sha256-gCoSpyFPQTIi86y+4xtRb+vsRkjZ2O6KcCj8mj8tcTQ=";
  };

  preBuild = ''
    echo "__version__ = '$version'" > src/uarray/_version.py
  '';

  build-system = [
    meson-python
    versioningit
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlags = [
    "--pyargs"
    "uarray"
  ];

  pythonImportsCheck = [ "uarray" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Universal array library";
    homepage = "https://github.com/Quansight-Labs/uarray";
    changelog = "https://github.com/Quansight-Labs/uarray/releases/tag/${src.tag}";
    license = lib.licenses.bsd0;
    maintainers = [ lib.maintainers.pbsds ];
  };
}
