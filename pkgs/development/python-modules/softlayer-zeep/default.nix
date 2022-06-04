{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, attrs
, cached-property
, isodate
, lxml
, platformdirs
, requests
, requests-toolbelt
, requests-file
, pytz
, freezegun
, pretend
, pytest-httpx
, pytest-asyncio
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "softlayer-zeep";
  version = "5.0.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff690c115eecaececa437bfe81430e9fdb49690e6465397c9dc77eb56b681e23";
  };

  propagatedBuildInputs = [
    attrs
    cached-property
    isodate
    lxml
    platformdirs
    requests
    requests-toolbelt
    requests-file
    pytz
  ];

  checkInputs = [
    freezegun
    pretend
    pytest-httpx
    pytest-asyncio
    pytestCheckHook
    requests-mock
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  pythonImportsCheck = [ "zeep" ];

  meta = {
    description = "A modern/fast Python SOAP client based on lxml / requests";
    homepage = "https://github.com/softlayer/softlayer-zeep";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
