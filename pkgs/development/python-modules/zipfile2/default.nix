{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "zipfile2";
  version = "0.0.12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cournape";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BwcEgW4XrQqz0Jmtbyxf8q0mWTJXv2dL3Tk7N/IYuMI=";
  };

  patches = [ ./no-setuid.patch ];

  pythonImportsCheck = [ "zipfile2" ];

  meta = with lib; {
    homepage = "https://github.com/cournape/zipfile2";
    description = "Backwards-compatible improved zipfile class";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.psfl;
    broken = pythonAtLeast "3.12"; # tests are failing because the signature of ZipInfo._decodeExtra changed
  };
}
