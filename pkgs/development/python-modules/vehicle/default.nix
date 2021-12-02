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
  version = "0.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-vehicle";
    rev = "v${version}";
    sha256 = "sha256-3DkfS8gx3C1/Vj8+IE7uxZ5i0cKJk0mJpBWQqAgb2Xo=";
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
    homepage = "https://github.com/frenck/python-vehicle";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
