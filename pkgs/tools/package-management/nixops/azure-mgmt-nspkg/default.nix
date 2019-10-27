{ pkgs
, buildPythonPackage
, fetchPypi
, azure-nspkg
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-mgmt-nspkg";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1rq92fj3kvnqkk18596dybw0kvhgscvc6cd8hp1dhy3wrkqnhwmq";
  };

  propagatedBuildInputs = [ azure-nspkg ];

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
