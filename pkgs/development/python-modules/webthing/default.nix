{ lib
, buildPythonPackage
, fetchFromGitHub
, ifaddr
, jsonschema
, pyee
, pythonOlder
, tornado
, zeroconf
}:

buildPythonPackage rec {
  pname = "webthing";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "WebThingsIO";
    repo = "webthing-python";
    rev = "v${version}";
    hash = "sha256-z4GVycdq25QZxuzZPLg6nhj0MAD1bHrsqph4yHgmRhg=";
  };

  propagatedBuildInputs = [
    ifaddr
    jsonschema
    pyee
    tornado
    zeroconf
  ];

  # No tests are present
  doCheck = false;

  pythonImportsCheck = [
    "webthing"
  ];

  meta = with lib; {
    description = "Python implementation of a Web Thing server";
    homepage = "https://github.com/WebThingsIO/webthing-python";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
