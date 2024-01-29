{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, flit-core
, dos2unix
, httpx
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zeversolarlocal";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ExZy5k5RE7k+D0lGmuIkGWrWQ+m24K2oqbUEg4BAVuY=";
  };

  nativeBuildInputs = [
    flit-core
    dos2unix
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  # the patch below won't apply unless we fix the line endings
  prePatch = ''
    dos2unix pyproject.toml
  '';

  patches = [
    # Raise the flit-core limit
    # https://github.com/sander76/zeversolarlocal/pull/4
    (fetchpatch {
      url = "https://github.com/sander76/zeversolarlocal/commit/bff072ea046de07eced77bc79eb8e90dfef1f53f.patch";
      hash = "sha256-tzFCwPzhAfwVfN5mLY/DMwRv7zGzx3ScBe+kKzkYcvo=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov zeversolarlocal --cov-report xml:cov.xml --cov-report term-missing -vv" ""
  '';

  disabledTests = [
    # Test requires network access
    "test_httpx_timeout"
  ];

  pythonImportsCheck = [
    "zeversolarlocal"
  ];

  meta = with lib; {
    description = "Python module to interact with Zeversolar inverters";
    homepage = "https://github.com/sander76/zeversolarlocal";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
