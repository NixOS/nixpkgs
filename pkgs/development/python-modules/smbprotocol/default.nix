{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pyspnego
, pytest-mock
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "smbprotocol";
  version = "1.5.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ym0fvljbwgl1h7f63m3psbsvqm64fipsrrmbqb97hrhfdzxqxpa";
  };

  propagatedBuildInputs = [
    cryptography
    pyspnego
    six
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "smbprotocol" ];

  meta = with lib; {
    description = "Python SMBv2 and v3 Client";
    homepage = "https://github.com/jborean93/smbprotocol";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
