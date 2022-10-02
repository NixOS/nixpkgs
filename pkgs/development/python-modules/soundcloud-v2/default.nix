{ lib
, buildPythonPackage
, fetchPypi
, dacite
, python-dateutil
, requests
}:

buildPythonPackage rec {
  pname = "soundcloud-v2";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a9c12aa22e71566e2ca6015267cabc1856afd79fa458f0fc43c44872c184741";
  };

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
