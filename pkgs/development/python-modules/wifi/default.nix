{ lib
, buildPythonPackage
, fetchFromGitHub
, pbkdf2
, pytestCheckHook
, pythonOlder
, substituteAll
, wirelesstools
}:

buildPythonPackage rec {
  pname = "wifi";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "rockymeza";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-scg/DvApvyQZtzDgkHFJzf9gCRfJgBvZ64CG/c2Cx8E=";
  };

  disabled = pythonOlder "2.6";

  postPatch = ''
    substituteInPlace wifi/scan.py \
      --replace "/sbin/iwlist" "${wirelesstools}/bin/iwlist"
  '';

  checkInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    pbkdf2
  ];

  pythonImportsCheck = [ "wifi" ];

  meta = with lib; {
    description = "Provides a command line wrapper for iwlist and /etc/network/interfaces";
    homepage = "https://github.com/rockymeza/wifi";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.bsd2;
  };
}
