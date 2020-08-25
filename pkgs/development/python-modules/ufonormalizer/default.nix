{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ufonormalizer";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nv80x7l7sya5wzyfk9ss93r6bjzjljpkw4k8gibxp1rqrzkdms4";
    extension = "zip";
  };

  meta = with lib; {
    description = "Script to normalize the XML and other data inside of a UFO";
    homepage = "https://github.com/unified-font-object/ufoNormalizer";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
