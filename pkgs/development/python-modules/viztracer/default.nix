{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  objprint,
  orjson,
  nix-update-script,
}:

buildPythonPackage rec {
  __structuredAttrs = true;

  pname = "viztracer";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gaogaotiantian";
    repo = "viztracer";
    tag = version;
    hash = "sha256-j+PbPZY9ZmOyF0nPEP/Ba34HPx2SUPNlaXAjj3GG9dc=";
  };

  build-system = [ setuptools ];

  dependencies = [ objprint ];

  optional-dependencies = {
    full = [ orjson ];
  };

  pythonImportsCheck = [ "viztracer" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Debugging and profiling tool that can trace and visualize python code execution";
    homepage = "https://github.com/gaogaotiantian/viztracer";
    changelog = "https://github.com/gaogaotiantian/viztracer/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nemeott ];
    mainProgram = "viztracer";
  };
}
