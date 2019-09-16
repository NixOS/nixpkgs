{ lib
, buildPythonPackage
, fetchPypi
, click
, h11
, httptools
, uvloop
, websockets
, wsproto
, isPy27
}:

buildPythonPackage rec {
  pname = "uvicorn";
  version = "0.8.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l8rfm30inx9pma893i7sby9h7y910k58841zqaajksn563b882k";
  };

  propagatedBuildInputs = [
    click
    h11
    httptools
    uvloop
    websockets
    wsproto
  ];

  checkPhase = ''
    $out/bin/uvicorn --help
  '';

  patches = [ ./setup.patch ];

  meta = with lib; {
    homepage = https://www.uvicorn.org/;
    description = "The lightning-fast ASGI server";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
