{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, httpx
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "zeversolarlocal";
  version = "1.1.0";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ExZy5k5RE7k+D0lGmuIkGWrWQ+m24K2oqbUEg4BAVuY=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
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
