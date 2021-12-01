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
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-vehicle";
    rev = "v${version}";
    sha256 = "0yiavz5sw8fjrh6m3mr8gyds7h6vaja3xy1516ajgz0qvijhqylg";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    yarl
  ];

  checkInputs = [
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
    homepage = "https://github.com/frenck/python-wled";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
