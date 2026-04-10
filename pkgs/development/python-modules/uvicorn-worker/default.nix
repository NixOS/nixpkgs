{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gunicorn,
  hatchling,
  httpx,
  pytestCheckHook,
  trustme,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "uvicorn-worker";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kludex";
    repo = "uvicorn-worker";
    tag = version;
    hash = "sha256-qfk3lkHwuGbRWj4D65EontmEgKtk7ILq6gZCrxcrrJU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    gunicorn
    uvicorn
  ];

  nativeCheckInputs = [
    gunicorn
    httpx
    pytestCheckHook
    trustme
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [ "uvicorn_worker" ];

  meta = {
    description = "Uvicorn worker for Gunicorn";
    homepage = "https://github.com/Kludex/uvicorn-worker";
    changelog = "https://github.com/Kludex/uvicorn-worker/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
