{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, pyjwt
, requests
, requests-toolbelt
}:

buildPythonPackage rec {
  pname = "webexteamssdk";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "CiscoDevNet";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bw28ag1iqyqlxz83m4qb3r94kipv5mpf3bsvc8zv5vh4dv52bp2";
  };

  propagatedBuildInputs = [
    future
    pyjwt
    requests
    requests-toolbelt
  ];

  # Tests require a Webex Teams test domain
  doCheck = false;
  pythonImportsCheck = [ "webexteamssdk" ];

  meta = with lib; {
    description = "Python module for Webex Teams APIs";
    homepage = "https://github.com/CiscoDevNet/webexteamssdk";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
