{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pillow,
}:

buildPythonPackage (finalAttrs: {
  pname = "wheezy.captcha";
  version = "3.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-UtTpgrPK5eRr7sq97jptjdJyvAyrM2oU07+GZr2Ad7s=";
  };

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  pythonImportsCheck = [ "wheezy.captcha" ];

  meta = {
    homepage = "https://wheezycaptcha.readthedocs.io/en/latest/";
    description = "Lightweight CAPTCHA library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Flakebi ];
  };
})
