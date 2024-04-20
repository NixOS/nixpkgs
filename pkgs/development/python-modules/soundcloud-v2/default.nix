{ lib
, buildPythonPackage
, fetchPypi
, dacite
, python-dateutil
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "soundcloud-v2";
  version = "1.3.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DiaCnIEXKSxyE4+MCq0KwdKWUGfWO3LAVwsMNEkOmqc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    dacite
    python-dateutil
    requests
  ];

  # tests require network
  doCheck = false;

  pythonImportsCheck = [ "soundcloud" ];

  meta = with lib; {
    description = "Python wrapper for the v2 SoundCloud API";
    homepage = "https://github.com/7x11x13/soundcloud.py";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
