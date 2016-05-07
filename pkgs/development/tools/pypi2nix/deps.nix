{ fetchurl
#, pypi_url ? "https://files.pythonhosted.org/packages"
, pypi_url ? "https://pypi.io/packages/source/packages"
}:

rec {

  pipVersion = "8.1.1";
  pipHash = "6b86f11841e89c8241d689956ba99ed7";
  pipWhlHash = "22db7b6a517a09c29d54a76650f170eb";

  setuptoolsVersion = "21.0.0";
  setuptoolsHash = "81964fdb89534118707742e6d1a1ddb4";
  setuptoolsWhlHash = "6027400d6870a7dad29952b7d2dfdc7b";

  zcbuildoutVersion = "2.5.1";
  zcbuildoutHash = "c88947a3c021ee1509a331c4fa9be187";

  zcrecipeeggVersion = "2.0.3";
  zcrecipeeggHash = "69a8ce276029390a36008150444aa0b4";

  wheelVersion = "0.29.0";
  wheelHash = "555a67e4507cedee23a0deb9651e452f";

  clickVersion = "6.6";
  clickHash = "d0b09582123605220ad6977175f3e51d";

  pipWhl = fetchurl {
    url = "https://pypi.python.org/packages/31/6a/0f19a7edef6c8e5065f4346137cc2a08e22e141942d66af2e1e72d851462/pip-${pipVersion}-py2.py3-none-any.whl";
    md5 = pipWhlHash;
  };

  setuptoolsWhl = fetchurl {
    url = "https://pypi.python.org/packages/15/b7/a76624e5a3b18c8c1c8d33a5240b34cdabb08aef2da44b536a8b53ba1a45/setuptools-${setuptoolsVersion}-py2.py3-none-any.whl";
    md5 = setuptoolsWhlHash;
  };

  pip = fetchurl {
    url = "${pypi_url}/source/p/pip/pip-${pipVersion}.tar.gz";
    md5 = pipHash;
  };

  setuptools = fetchurl {
    url = "${pypi_url}/source/s/setuptools/setuptools-${setuptoolsVersion}.tar.gz";
    md5 = setuptoolsHash;
  };

  zcbuildout = fetchurl {
    url = "${pypi_url}/source/z/zc.buildout/zc.buildout-${zcbuildoutVersion}.tar.gz";
    md5 = zcbuildoutHash;
  };

  zcrecipeegg = fetchurl {
    url = "${pypi_url}/source/z/zc.recipe.egg/zc.recipe.egg-${zcrecipeeggVersion}.tar.gz";
    md5 = zcrecipeeggHash;
  };

  wheel = fetchurl {
    url = "${pypi_url}/source/w/wheel/wheel-${wheelVersion}.tar.gz";
    md5 = wheelHash;
  };

  click = fetchurl {
    url = "${pypi_url}/source/c/click/click-${clickVersion}.tar.gz";
    md5 = clickHash;
  };

}
