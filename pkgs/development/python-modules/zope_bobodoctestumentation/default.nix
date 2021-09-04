{ lib, buildPythonPackage, fetchPypi
, manuel, six, webtest, zope_testing
}:

buildPythonPackage rec {
  pname = "zope_bobodoctestumentation";
  version = "2.2.0";

  src = fetchPypi {
    pname = "bobodoctestumentation";
    inherit version;
    sha256 = "ad61cd5753c58351940dfdc9713d4c188bf51f7bd793626f82e6f1f93f328195";
  };

  propagatedBuildInputs = [
    manuel
    six
    webtest
    zope_testing
  ];

  meta = with lib; {
    description = "Bobo tests and documentation";
    downloadPage = "https://pypi.org/project/bobodoctestumentation/";
    homepage = "https://github.com/zopefoundation/bobo/tree/master/bobodoctestumentation";
    license = licenses.zpl21;
    maintainers = with maintainers; [ superherointj ];
  };
}
