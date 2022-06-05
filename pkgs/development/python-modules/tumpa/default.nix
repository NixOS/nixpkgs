{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pyside2
, johnnycanencrypt
, pythonOlder
, wrapQtAppsHook
}:

buildPythonPackage rec {
  pname = "tumpa";
  version = "0.1.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kushaldas";
    repo = "tumpa";
    rev = "v${version}";
    sha256 = "17nhdildapgic5l05f3q1wf5jvz3qqdjv543c8gij1x9rdm8hgxi";
  };

  propagatedBuildInputs = [
    setuptools
    johnnycanencrypt
    pyside2
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  doCheck = false;

  meta = with lib; {
    description = "OpenPGP key creation and smartcard access";
    homepage = "https://github.com/kushaldas/tumpa";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
