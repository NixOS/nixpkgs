{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ukpostcodeparser";
  version = "1.1.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "UkPostcodeParser";
    inherit version;
    sha256 = "930264efa293db80af0103a4fe9c161b06365598d24bb6fe5403f3f57c70530e";
  };

  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "UK Postcode parser";
    homepage = "https://github.com/hamstah/ukpostcodeparser";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ siddharthist ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "UK Postcode parser";
    homepage = "https://github.com/hamstah/ukpostcodeparser";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
