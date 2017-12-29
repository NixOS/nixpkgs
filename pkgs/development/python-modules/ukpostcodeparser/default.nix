{ stdenv, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "UkPostcodeParser";
  version = "1.1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7a7ac19d48897637c7aaa2f2970288f1c260e4a99140bf04c6086cf65576c6b";
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
