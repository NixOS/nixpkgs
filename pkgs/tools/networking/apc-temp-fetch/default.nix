{ lib
, buildPythonApplication
, fetchPypi
, pythonOlder
, requests
}:

buildPythonApplication rec {
  pname = "apc-temp-fetch";
  version = "0.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "APC-Temp-fetch";
    inherit version;
    hash = "sha256-lXGj/xrOkdMMYvuyVVSCojjQlzISFUT14VTn//iOARo=";
  };

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [
    "APC_Temp_fetch"
  ];

  meta = with lib; {
    description = "unified temperature fetcher interface to several UPS network adapters";
    homepage = "https://github.com/YZITE/APC_Temp_fetch";
    license = licenses.asl20;
    maintainers = [ maintainers.fogti ];
  };
}
