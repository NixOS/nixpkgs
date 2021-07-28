{ lib
, stdenv
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
  version = "1.6.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pyjnmrkiqcd0r1s6zl8w91zy0605k7cyy5n4cvv52079gy0axhd";
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

  disabledTests = lib.optionals stdenv.isDarwin [
    # https://github.com/jborean93/smbprotocol/issues/119
    "test_copymode_local_to_local_symlink_dont_follow"
    "test_copystat_local_to_local_symlink_dont_follow_fail"

    # fail in sandbox due to networking
    "test_small_recv"
    "test_recv_"
  ];

  pythonImportsCheck = [ "smbprotocol" ];

  meta = with lib; {
    description = "Python SMBv2 and v3 Client";
    homepage = "https://github.com/jborean93/smbprotocol";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
