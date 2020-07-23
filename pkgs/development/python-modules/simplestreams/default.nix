{ lib, fetchgit, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  pname = "simplestreams";
  version = "2020-06-29";

  src = fetchgit {
    url = "https://git.launchpad.net/simplestreams";
    rev = "ff048fdb5d2f4e5b5218107d42f1c86f0a783bfb";
    sha256 = "0y0mhzjyzp90nmfxasknajfmra5jhll5sf3v67sdkwlscb2f3s96";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://launchpad.net/simplestreams";
    description = "A python library and some tools for interacting with simple streams format";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mt-caret ];
  };
}
