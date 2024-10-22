{ lib
, buildPythonPackage
, fetchPypi
, numpy
, torch
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "ultralytics_thop";
  version = "2.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd098468a5a50609c28906c557240c0d1603175c5420843de5ebefd7c83376ab";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    torch
  ];

  pythonImportsCheck = [ "thop" ];

  doCheck = true;

  meta = with lib; {
    description = "Profile PyTorch models for FLOPs and parameters.";
    homepage = "https://github.com/ultralytics/thop";
    licenses = with licenses; [ agpl3 ];
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
