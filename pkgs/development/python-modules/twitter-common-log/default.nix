{
  lib,
  buildPythonPackage,
  fetchPypi,
  twitter-common-options,
  twitter-common-dirutil,
}:

buildPythonPackage rec {
  pname = "twitter.common.log";
  version = "0.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7160a864eed30044705e05b816077dd193aec0c66f50ef1c077b7f8490e0d06a";
  };

  propagatedBuildInputs = [
    twitter-common-options
    twitter-common-dirutil
  ];

  meta = with lib; {
    description = "Twitter's common logging library";
    homepage = "https://twitter.github.io/commons/";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
