{ lib
, buildPythonPackage
, fetchPypi
, pillow
}:

buildPythonPackage rec {
  pname = "wheezy.captcha";
  version = "3.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UtTpgrPK5eRr7sq97jptjdJyvAyrM2oU07+GZr2Ad7s=";
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
