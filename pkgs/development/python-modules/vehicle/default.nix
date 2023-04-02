{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "vehicle";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-vehicle";
    rev = "refs/tags/v${version}";
    hash = "sha256-7WW/gEtS4KLcAujQ+pypDpk9VaacMWj/RP7OpLxUrDs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  pythonImportsCheck = [
    "vehicle"
  ];

  meta = with lib; {
    description = "Python client providing RDW vehicle information";
    homepage = "https://github.com/frenck/python-vehicle";
    changelog = "https://github.com/frenck/python-vehicle/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
