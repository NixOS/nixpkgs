{ lib
, buildPythonPackage
, docopt
, fetchFromGitHub
, requests
, requests-oauthlib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tellduslive";
  version = "0.10.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "molobrakos";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aqhj6fq2z2qb4jyk23ygjicf5nlj8lkya7blkyqb7jra5k1gyg0";
  };

  propagatedBuildInputs = [
    docopt
    requests
    requests-oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "tellduslive"
  ];

  meta = with lib; {
    description = "Python module to communicate with Telldus Live";
    homepage = "https://github.com/molobrakos/tellduslive";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ fab ];
  };
}
