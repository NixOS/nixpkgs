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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kludex";
    repo = "uvicorn-worker";
    tag = version;
    hash = "sha256-a5L4H1Bym5Dx9/pGL/Vz6ZO699t/1Wmc1ExIb0t/ISc=";
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
