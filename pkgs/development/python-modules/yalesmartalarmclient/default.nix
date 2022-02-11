{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "yalesmartalarmclient";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "domwillcode";
    repo = "yale-smart-alarm-client";
    rev = "v${version}";
    sha256 = "sha256-LcHXw4rZhQ942EhiGrRTf3MpT7G5OFSX8QbpxVjvTTo=";
  };

  propagatedBuildInputs = [
    backoff
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "yalesmartalarmclient" ];

  meta = with lib; {
    description = "Python module to interface with Yale Smart Alarm Systems";
    homepage = "https://github.com/domwillcode/yale-smart-alarm-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
