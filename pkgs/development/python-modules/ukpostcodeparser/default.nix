{ stdenv, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "UkPostcodeParser";
  version = "1.1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "930264efa293db80af0103a4fe9c161b06365598d24bb6fe5403f3f57c70530e";
  };

  doCheck = false;

  meta = with lib; {
    description = "UK Postcode parser";
    homepage    = https://github.com/hamstah/ukpostcodeparser;
    license     = licenses.publicDomain;
    maintainers = with maintainers; [ siddharthist ];
    platforms   = platforms.unix;
  };
}
