{ stdenv, lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "UkPostcodeParser";
  version = "1.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v8k91xhg5fr6sk91am93abjarw950ray7b9q3w5j25agjsxgcsf";
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
