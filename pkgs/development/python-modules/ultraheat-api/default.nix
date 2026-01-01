{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyserial,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ultraheat-api";
  version = "0.5.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "ultraheat_api";
    inherit version;
    hash = "sha256-rRQTjV9hyUawMaXBgUx/d6pQjM8ffjcFJE2x08Cf4Gw=";
  };

  propagatedBuildInputs = [ pyserial ];

  # Source is not tagged, only PyPI releases
  doCheck = false;

  pythonImportsCheck = [ "ultraheat_api" ];

<<<<<<< HEAD
  meta = {
    description = "Module for working with data from Landis+Gyr Ultraheat heat meter unit";
    homepage = "https://github.com/vpathuis/uh50";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module for working with data from Landis+Gyr Ultraheat heat meter unit";
    homepage = "https://github.com/vpathuis/uh50";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
