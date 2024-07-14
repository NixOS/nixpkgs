{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ukpostcodeparser";
  version = "1.1.2";

  src = fetchPypi {
    pname = "UkPostcodeParser";
    inherit version;
    hash = "sha256-kwJk76KT24CvAQOk/pwWGwY2VZjSS7b+VAPz9XxwUw4=";
  };

  doCheck = false;

  meta = with lib; {
    description = "UK Postcode parser";
    homepage = "https://github.com/hamstah/ukpostcodeparser";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.unix;
  };
}
