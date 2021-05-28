{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ufonormalizer";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rn64a0i151qk6h5f9pijcmja195i2d6f8jbi5h4xkgkinm9wwzj";
    extension = "zip";
  };

  meta = with lib; {
    description = "Script to normalize the XML and other data inside of a UFO";
    homepage = "https://github.com/unified-font-object/ufoNormalizer";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
