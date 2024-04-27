{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "unix-ar";
  version = "0.2.1";
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit format version;
    pname = "unix_ar";
    hash = "sha256-Kstxi8Ewi/gOW52iYU2CQswv475M2LL9Rxm84Ymq/PE=";
  };

  meta = with lib; {
    description = "AR file handling for Python (including .deb files)";
    homepage = "https://github.com/getninjas/unix_ar";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tirimia ];
    platforms = with platforms; linux ++ darwin;
  };
}
