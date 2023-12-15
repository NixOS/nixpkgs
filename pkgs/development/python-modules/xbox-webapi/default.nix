{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, appdirs
, ecdsa
, ms-cv
, pydantic
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xbox-webapi";
  version = "2.0.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "OpenXbox";
    repo = "xbox-webapi-python";
    rev = "v${version}";
    sha256 = "0li0bq914xizx9fj49s1iwfrv4bpzvl74bwsi5a34r9yizw02cvz";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    aiohttp
    appdirs
    ecdsa
    ms-cv
    pydantic
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  meta = with lib; {
    description = "Library to authenticate with Windows Live/Xbox Live and use their API";
    homepage = "https://github.com/OpenXbox/xbox-webapi-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
