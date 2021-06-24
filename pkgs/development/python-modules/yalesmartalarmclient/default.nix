{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "yalesmartalarmclient";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "domwillcode";
    repo = "yale-smart-alarm-client";
    rev = "v${version}";
    sha256 = "0fscp9n66h8a8khvjs2rjgm95xsdckpknadnyxqdmhw3hlj0aw6h";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "yalesmartalarmclient" ];

  meta = with lib; {
    description = "Python module to interface with Yale Smart Alarm Systems";
    homepage = "https://github.com/mampfes/python-wiffi";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
