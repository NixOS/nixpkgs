# Code structure based off the python btrfs nixpkgs module
{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  apscheduler,
  aiohttp,
  phonenumbers,
  websockets,
  pydantic,
  packaging,
}:
buildPythonPackage rec {
  pname = "signalbot";
  version = "0.19.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qT6IkeIB4jxZEtUExYzVwdfEirnGZj61J/d1e+x1Jxw=";
  };

  dependencies = [
    poetry-core
    apscheduler
    aiohttp
    phonenumbers
    pydantic
    websockets
    packaging
  ];

  pythonImportsCheck = [ "signalbot" ];

  meta = with lib; {
    description = "Python package to build your own Signal bots";
    homepage = "https://github.com/filipre/signalbot";
    license = lib.licenses.mit;
    maintainers = with maintainers; [
      Fireye04
    ];
  };
}
