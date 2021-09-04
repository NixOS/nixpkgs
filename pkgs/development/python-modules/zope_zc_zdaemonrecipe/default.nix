{ lib, buildPythonPackage, fetchPypi
, setuptools, zc_buildout, zconfig/*, zope_zc_recipe_egg */
, six, zdaemon, zope_testing, zope_testrunner
}:

buildPythonPackage rec {
  pname = "zope_zc_zdaemonrecipe";
  version = "1.0.0";

  src = fetchPypi {
    pname = "zc.zdaemonrecipe";
    inherit version;
    sha256 = "e89693f40655164c818f04ff7e70d858eae809598a0afea406f201d025722b43";
  };

  propagatedBuildInputs = [
    setuptools
    zc_buildout
    #zope_zc_recipe_egg # `zc.recipe.egg` is broken!
    zconfig
  ];

  checkInputs = [
    six
    zdaemon
    zope_testing
    zope_testrunner
  ];

  meta = with lib; {
    broken = true;
    description = "ZC Buildout recipe for zdaemon scripts";
    downloadPage = "https://pypi.org/project/zc.zdaemonrecipe";
    homepage = "https://github.com/zopefoundation/zc.zdaemonrecipe";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
