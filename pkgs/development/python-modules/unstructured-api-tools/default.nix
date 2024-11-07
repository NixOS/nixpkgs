{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # propagated build inputs
  click,
  fastapi,
  jinja2,
  mypy,
  nbconvert,
  python-multipart,
  pandas,
  types-requests,
  types-ujson,
  uvicorn,
  autoflake,
  # native check inputs
  pytestCheckHook,
  black,
  coverage,
  flake8,
  httpx,
  ipython,
  pytest-cov-stub,
  requests,
  requests-toolbelt,
  nbdev,
  pytest-mock,
}:
let
  version = "0.10.11";
in
buildPythonPackage {
  pname = "unstructured-api-tools";
  inherit version;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-api-tools";
    rev = "refs/tags/${version}";
    hash = "sha256-t1fK40ayR2bxc1iMIwvn/OHuyVlR98Gq+NpIhOmaP+4=";
  };

  propagatedBuildInputs = [
    click
    fastapi
    jinja2
    mypy
    nbconvert
    python-multipart
    pandas
    types-requests
    types-ujson
    uvicorn
    autoflake
  ] ++ uvicorn.optional-dependencies.standard;

  pythonImportsCheck = [ "unstructured_api_tools" ];

  # test require file generation but it complains about a missing file mypy
  doCheck = false;
  # preCheck = ''
  #   substituteInPlace Makefile \
  #     --replace "PYTHONPATH=." "" \
  #     --replace "mypy" "${mypy}/bin/mypy"
  #   make generate-test-api
  # '';

  nativeCheckInputs = [
    pytestCheckHook
    black
    coverage
    flake8
    httpx
    ipython
    pytest-cov-stub
    requests
    requests-toolbelt
    nbdev
    pytest-mock
  ];

  meta = with lib; {
    description = "";
    mainProgram = "unstructured_api_tools";
    homepage = "https://github.com/Unstructured-IO/unstructured-api-tools";
    changelog = "https://github.com/Unstructured-IO/unstructured-api-tools/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
