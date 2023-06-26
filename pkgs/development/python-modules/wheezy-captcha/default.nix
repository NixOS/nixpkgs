{ lib
, buildPythonPackage
, fetchPypi
, pillow
}:

buildPythonPackage rec {
  pname = "wheezy.captcha";
  version = "3.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PdtOhoVOopQsX2raPqh0P8meM8/MysgKsIe27HNtl3s=";
  };

  propagatedBuildInputs = [ pillow ];

  pythonImportsCheck = [ "wheezy.captcha" ];

  meta = with lib; {
    homepage = "https://wheezycaptcha.readthedocs.io/en/latest/";
    description = "A lightweight CAPTCHA library";
    license = licenses.mit;
    maintainers = with maintainers; [ Flakebi ];
  };
}
