{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "yalesmartalarmclient";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "domwillcode";
    repo = "yale-smart-alarm-client";
    rev = "v${version}";
    sha256 = "11i7vh61a5xfv32zm7rkigl010wzd6snag6sf7w38256j95nnb05";
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
