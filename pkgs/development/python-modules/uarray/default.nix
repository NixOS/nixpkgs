{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-build-core,
  setuptools,
  setuptools-scm,
  cmake,
  ninja,
  matchpy,
  numpy,
  astunparse,
  typing-extensions,
  nix-update-script,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "uarray";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "uarray";
    tag = version;
    hash = "sha256-Nog7jvRG/EFf3n3W2DWC7UML5NyrlaaS0ECis5rtCSk=";
  };

  build-system = [
    scikit-build-core
    setuptools
    setuptools-scm
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    astunparse
    matchpy
    numpy
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  # Tests must be run from outside the source directory
  preCheck = ''
    cd $TMP
  '';

  pytestFlags = [
    "--pyargs"
    "uarray"
  ];

  pythonImportsCheck = [ "uarray" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Universal array library";
    homepage = "https://github.com/Quansight-Labs/uarray";
    changelog = "https://github.com/Quansight-Labs/uarray/releases/tag/${src.tag}";
    license = licenses.bsd0;
    maintainers = [ lib.maintainers.pbsds ];
  };
}
