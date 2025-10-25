{
  lib,
  python,
  fetchPypi,
}:

python.pkgs.buildPythonPackage rec {
  pname = "twentyc-rpc";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "twentyc.rpc";
    inherit version;
    hash = "sha256-sR0C662lfdquyr1he6aGrPS9/MsB77LwL6nXrnNhTrE=";
  };

  build-system = [
    python.pkgs.poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  dependencies = with python.pkgs; [
    requests
    setuptools
  ];

  pythonImportsCheck = [
    "twentyc.rpc"
  ];

  meta = {
    description = "Client for 20c's RESTful API";
    homepage = "https://pypi.org/project/twentyc.rpc/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xgwq ];
    mainProgram = "twentyc-rpc";
  };
}
