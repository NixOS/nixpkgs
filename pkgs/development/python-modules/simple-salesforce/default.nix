{ lib
, fetchFromGitHub
, buildPythonPackage
, requests
, pyopenssl
, cryptography
, idna
, mock
, isPy27
, nose
, pytz
, responses
}:

buildPythonPackage rec {
  pname = "simple-salesforce";
  version = "0.75.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "07qbmifbj7awl332l1w15b6pdzfyj1lnzw2adasaiqy8icw5kskc";
  };

  propagatedBuildInputs = [
    requests
    pyopenssl
    cryptography
    idna
  ];

  checkInputs = [
    nose
    pytz
    responses
  ] ++ lib.optionals isPy27 [ mock ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "mock==1.0.1" "mock"
  '';

  meta = with lib; {
    description = "A very simple Salesforce.com REST API client for Python";
    homepage = "https://github.com/simple-salesforce/simple-salesforce";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };

}
