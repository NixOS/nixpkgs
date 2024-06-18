{
  buildPythonPackage,
  fetchPypi,
  lib,
  lxml,
}:

buildPythonPackage rec {
  pname = "xmljson";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4158e66aa1e62ee39f7f80eb2fe4f767670ba3c0d5de9804420dc53427fdec8";
  };

  nativeCheckInputs = [ lxml ];

  meta = with lib; {
    description = "Converts XML into dictionary structures and vice-versa";
    mainProgram = "xml2json";
    homepage = "https://github.com/sanand0/xmljson";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rakesh4g ];
  };
}
