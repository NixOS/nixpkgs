{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  isPyPy,
  brotli,
  brotlicffi,
  starlette,
  zstandard,
  pytestCheckHook,
  httpx,
  trio,
}:

buildPythonPackage rec {
  pname = "starlette-compress";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zaczero";
    repo = "starlette-compress";
    tag = version;
    hash = "sha256-JRg0WeMVTYnSh2an+/duSXzAigbjbCZ9NUsSNpXlFg8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    (if isPyPy then brotlicffi else brotli)
    starlette
    zstandard
  ];

  checkInputs = [
    httpx
    trio
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "starlette_compress" ];

  meta = {
    description = "Compression middleware for Starlette - supporting ZStd, Brotli, and GZip";
    homepage = "https://pypi.org/p/starlette-compress";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [
      wrvsrx
      Zaczero
    ];
  };
}
