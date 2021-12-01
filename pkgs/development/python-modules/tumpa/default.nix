{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pyside2
, johnnycanencrypt
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tumpa";
  version = "0.1.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "tumpa";
    rev = "v${version}";
    sha256 = "1wvs64s0jxn4p8zr643d2hcczw3a175r6ib3481gdhjx38kgxjbq";
  };

  propagatedBuildInputs = [
    setuptools
    johnnycanencrypt
    pyside2
  ];

  doCheck = false;

  meta = with lib; {
    description = "OpenPGP key creation and smartcard access";
    homepage = "https://github.com/kushaldas/tumpa";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
