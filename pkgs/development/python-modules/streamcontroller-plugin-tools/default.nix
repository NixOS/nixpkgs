{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  loguru,
  rpyc,
}:
buildPythonPackage rec {
  pname = "streamcontroller-plugin-tools";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "StreamController";
    repo = "streamcontroller-plugin-tools";
    rev = version;
    hash = "sha256-dQZPRSzHhI3X+Pf7miwJlECGFgUfp68PtvwXAmpq5/s=";
  };

  dependencies = [
    loguru
    rpyc
  ];

  pythonImportsCheck = [ "streamcontroller_plugin_tools" ];

<<<<<<< HEAD
  meta = {
    description = "StreamController plugin tools";
    homepage = "https://github.com/StreamController/streamcontroller-plugin-tools";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "StreamController plugin tools";
    homepage = "https://github.com/StreamController/streamcontroller-plugin-tools";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
