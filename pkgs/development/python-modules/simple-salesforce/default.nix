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
  version = "0.74.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1n960xgrnmv20l31nm0im7pb4nfa83bmx4x4clqrh2jkpzq3ric0";
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
