{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "streamlabswater";
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "stream-python";
    rev = "v${version}";
    sha256 = "1lh1i1ksic9yhxnwc7mqm5qla98x85dfwj846kwldwam0vcrqlk7";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "streamlabswater" ];

  meta = with lib; {
    description = "Python library for the StreamLabs API";
    homepage = "https://github.com/streamlabswater/stream-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
