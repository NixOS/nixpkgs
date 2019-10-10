{ buildPythonPackage
, fetchPypi
, tqdm    
, requests
, pytorch   
, numpy   
, six     
, lib
}:

buildPythonPackage rec {
  version = "0.4.0";
  pname = "torchtext";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e04ca965fb1d74161fd1f4b5222ee4fa1ad6c02f1e7df213495883384f2fa408";
  };

  propagatedBuildInputs = [ tqdm requests pytorch numpy six ];

  meta = {
    homepage = https://pytorch.org;
    description = "Data loaders and abstractions for text and NLP";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vladmaraev ];
  };
}
