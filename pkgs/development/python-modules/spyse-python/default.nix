{ lib
, buildPythonPackage
, dataclasses-json
, fetchFromGitHub
, limiter
, pythonOlder
, requests
, responses
}:

buildPythonPackage rec {
  pname = "spyse-python";
  version = "2.2.3";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "spyse-com";
    repo = pname;
    rev = "v${version}";
    sha256 = "041k0037anwaxp2mh7mdk8rdsw9hdr3arigyyqfxfn35x8j41c3k";
  };

  propagatedBuildInputs = [
    requests
    dataclasses-json
    responses
    limiter
  ];

  # Tests requires an API token
  doCheck = false;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'dataclasses~=0.6'," "" \
      --replace "responses~=0.13.3" "responses>=0.13.3"
  '';

  pythonImportsCheck = [
    "spyse"
  ];

  meta = with lib; {
    description = "Python module for spyse.com API";
    homepage = "https://github.com/spyse-com/spyse-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
