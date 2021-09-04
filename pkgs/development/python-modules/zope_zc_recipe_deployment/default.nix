{ lib, buildPythonPackage, fetchPypi
, setuptools, six
, zc_buildout, zope_testing, zope_testrunner
}:

buildPythonPackage rec {
  pname = "zope_zc_recipe_deployment";
  version = "1.3.0";

  src = fetchPypi {
    pname = "zc.recipe.deployment";
    inherit version;
    sha256 = "003f7ef6c099cfdd9c4f11b00ec03343bd4ded947f131e8c666d0be966a59803";
  };

  propagatedBuildInputs = [
    setuptools
    six
  ];

  checkInputs = [
    zc_buildout
    zope_testing
    zope_testrunner
  ];

  meta = with lib; {
    description = "ZC Buildout recipe for Unix deployments";
    downloadPage = "https://pypi.org/project/zc.recipe.deployment/";
    homepage = "https://github.com/zopefoundation/zc.recipe.deployment";
    license = licenses.zpl21;
    maintainers = with maintainers; [ superherointj ];
  };
}
