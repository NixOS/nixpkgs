{ lib
, buildPythonPackage
, devpi-common
, fetchPypi
, glibcLocales
, pkginfo
, pluggy
, py
, setuptools
, beautifulsoup4
, pyramid
, whoosh
, devpi-server
, pyramid_chameleon
, readme_renderer
, defusedxml
}:

buildPythonPackage rec {
  pname = "devpi-web";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-chR7VaOKiyFWar5OYxng1P+/VE+g7/N0kjlUG2a+JaE=";
  };

  buildInputs = [
    glibcLocales
    devpi-server
  ];

  propagatedBuildInputs = [
    devpi-common
    defusedxml
    pkginfo
    pluggy
    beautifulsoup4
    py
    whoosh
    pyramid_chameleon
    pyramid
    setuptools
    readme_renderer
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "http://doc.devpi.net";
    description = "Addon for devpi-server, a searchable web-interface";
    license = licenses.mit;
    maintainers = [ "jozi" ];
  };
}