{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "umalqurra";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "719f6a36f908ada1c29dae0d934dd0f1e1f6e3305784edbec23ad719397de678";
  };

  # No tests included
  doCheck = false;

  # See for license
  # https://github.com/tytkal/python-hijiri-ummalqura/issues/4
  meta = with lib; {
    description = "Date Api that support Hijri Umalqurra calendar";
    homepage = "https://github.com/tytkal/python-hijiri-ummalqura";
    license = with licenses; [ publicDomain ];
  };

}
