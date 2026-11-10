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
    hash = "sha256-kwJk76KT24CvAQOk/pwWGwY2VZjSS7b+VAPz9XxwUw4=";
  };

  doCheck = false;

  meta = {
    description = "UK Postcode parser";
    homepage = "https://github.com/hamstah/ukpostcodeparser";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ siddharthist ];
    platforms = lib.platforms.unix;
  };
}
