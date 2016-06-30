{ fetchurl
}:

rec {

  pipVersion = "8.1.2";
  pipHash = "87083c0b9867963b29f7aba3613e8f4a";
  pipWhlHash = "0570520434c5b600d89ec95393b2650b";

  setuptoolsVersion = "23.0.0";
  setuptoolsHash = "100a90664040f8ff232fbac02a4c5652";
  setuptoolsWhlHash = "a066fd7bfb8faaad763acbdbcb290199";

  zcbuildoutVersion = "2.5.2";
  zcbuildoutHash = "06a21fb02528c07aa0db31de0389a244";

  zcrecipeeggVersion = "2.0.3";
  zcrecipeeggHash = "69a8ce276029390a36008150444aa0b4";

  wheelVersion = "0.29.0";
  wheelHash = "555a67e4507cedee23a0deb9651e452f";

  clickVersion = "6.6";
  clickHash = "d0b09582123605220ad6977175f3e51d";

  sixVersion = "1.10.0";
  sixHash = "34eed507548117b2ab523ab14b2f8b55";

  attrsVersion = "16.0.0";
  attrsHash = "5bcdd418f6e83e580434c63067c08a73";

  effectVersion = "0.10.1";
  effectHash = "6a6fd28fb44179ce01a148d4e8bdbede";


  # --- wheels used to bootstrap python environment ---------------------------

  pipWhl = fetchurl {
    url = "https://pypi.python.org/packages/9c/32/004ce0852e0a127f07f358b715015763273799bd798956fa930814b60f39/pip-${pipVersion}-py2.py3-none-any.whl";
    md5 = pipWhlHash;
  };

  setuptoolsWhl = fetchurl {
    url = "https://pypi.python.org/packages/74/7c/c75c4f4032a4627406db06b742cdc7ba24c4833cd423ea7e22882380abde/setuptools-${setuptoolsVersion}-py2.py3-none-any.whl";
    md5 = setuptoolsWhlHash;
  };


  # --- python packages needed ------------------------------------------------

  pip = fetchurl {
    url = "https://pypi.python.org/packages/e7/a8/7556133689add8d1a54c0b14aeff0acb03c64707ce100ecd53934da1aa13/pip-${pipVersion}.tar.gz";
    md5 = pipHash;
  };

  setuptools = fetchurl {
    url = "https://pypi.python.org/packages/45/5e/79ca67a0d6f2f42bfdd9e467ef97398d6ad87ee2fa9c8cdf7caf3ddcab1e/setuptools-${setuptoolsVersion}.tar.gz";
    md5 = setuptoolsHash;
  };

  zcbuildout = fetchurl {
    url = "https://pypi.python.org/packages/ec/a1/60214738d5dcb199ad97034ecf349d18f3ab69659df827a5e182585bfe48/zc.buildout-${zcbuildoutVersion}.tar.gz";
    md5 = zcbuildoutHash;
  };

  zcrecipeegg = fetchurl {
    url = "https://pypi.python.org/packages/08/5e/ade683d229d77ed457017145672f1be4fd98be60f1a5344109a4e66a7d54/zc.recipe.egg-${zcrecipeeggVersion}.tar.gz";
    md5 = zcrecipeeggHash;
  };

  wheel = fetchurl {
    url = "https://pypi.python.org/packages/c9/1d/bd19e691fd4cfe908c76c429fe6e4436c9e83583c4414b54f6c85471954a/wheel-${wheelVersion}.tar.gz";
    md5 = wheelHash;
  };

  click = fetchurl {
    url = "https://pypi.python.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-${clickVersion}.tar.gz";
    md5 = clickHash;
  };

}
