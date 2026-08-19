{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  typer,

  # test dependencies
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "typer-di";
  version = "0.1.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "greendwin";
    repo = "typer_di";
    rev = "7faca500976dc04afeb4430be570ef1179e7470c"; # v0.1.5
    hash = "sha256-R4SsdAvwMvO/Jnhlr+xOYWyYtTu0sVTzz/OY0xa61Es=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "typer-slim" "typer"
  '';

  build-system = [ poetry-core ];

  dependencies = [ typer ];

  pythonImportsCheck = [ "typer_di" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/greendwin/typer_di/tree/${finalAttrs.src.rev}#release-notes";
    description = "Extension for typer for dependency injection like in FastAPI";
    homepage = "https://github.com/greendwin/typer_di";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
