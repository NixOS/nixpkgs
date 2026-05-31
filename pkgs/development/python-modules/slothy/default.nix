{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  gcc,
  llvm,
  ortools,
  sympy,
  unicorn,
}:

buildPythonPackage rec {
  pname = "slothy";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slothy-optimizer";
    repo = "slothy";
    tag = version;
    hash = "sha256-1seD/wqAyEcv5HJFO8j53ARd64fddGropA6xk0dq2yk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ortools
    sympy
    unicorn
  ];

  # slothy shells out to `gcc` and the llvm binutils at runtime; extend
  # PATH at import time so the library works in a plain withPackages env.
  postPatch = ''
      substituteInPlace slothy/__init__.py \
        --replace-fail 'from slothy.core.slothy import Slothy' \
          'import os
    os.environ["PATH"] = "${
      lib.makeBinPath [
        gcc
        llvm
      ]
    }" + os.pathsep + os.environ.get("PATH", "")
    from slothy.core.slothy import Slothy'
  '';

  pythonRelaxDeps = true;

  pythonImportsCheck = [ "slothy" ];

  installCheckPhase = ''
    runHook preInstallCheck
    python3 test.py --silent --tests aarch64_simple0_a55
    runHook postInstallCheck
  '';

  meta = {
    description = "Assembly superoptimization via constraint solving";
    homepage = "https://slothy-optimizer.github.io/slothy";
    changelog = "https://github.com/slothy-optimizer/slothy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkannwischer ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
