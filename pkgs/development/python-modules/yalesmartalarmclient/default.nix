{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "yalesmartalarmclient";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "domwillcode";
    repo = "yale-smart-alarm-client";
    rev = "v${version}";
    sha256 = "sha256-waWi3QnH7xQZh5iYklISCvfAaBdH5k+Y10huZuTNlSc=";
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
