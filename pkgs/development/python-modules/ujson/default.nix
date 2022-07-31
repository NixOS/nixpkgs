{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, pytestCheckHook
, pythonOlder
, setuptools-scm
, fetchpatch
}:

buildPythonPackage rec {
  pname = "ujson";
  version = "5.1.0";
  disabled = isPyPy || pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a88944d2f99db71a3ca0c63d81f37e55b660edde0b07216fb65a3e46403ef004";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-31117.patch";
      url = "https://github.com/ultrajson/ultrajson/commit/b21da40ead640b6153783dad506e68b4024056ef.patch";
      sha256 = "sha256-H8cxJ54ESZqtvJzC1W7Dl7WmdApxhLeSllsQW3uG1yc=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ujson" ];

  meta = with lib; {
    description = "Ultra fast JSON encoder and decoder";
    homepage = "https://github.com/ultrajson/ultrajson";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
