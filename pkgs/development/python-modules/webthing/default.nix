{ lib
, buildPythonPackage
, fetchFromGitHub
, ifaddr
, jsonschema
, pyee
, tornado
, zeroconf
}:

buildPythonPackage rec {
  pname = "webthing";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "WebThingsIO";
    repo = "webthing-python";
    rev = "v${version}";
    sha256 = "06264rwchy4qmbn7lv7m00qg864y7aw3rngcqqcr9nvaqz4rb0fg";
  };

  propagatedBuildInputs = [
    ifaddr
    jsonschema
    pyee
    tornado
    zeroconf
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "webthing" ];

  meta = with lib; {
    description = "Python implementation of a Web Thing server";
    homepage = "https://github.com/WebThingsIO/webthing-python";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
