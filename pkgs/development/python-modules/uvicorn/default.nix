{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, h11
, httptools
, uvloop
, websockets
, wsproto
, pytest
, requests
, isPy27
}:

buildPythonPackage rec {
  pname = "uvicorn";
  version = "0.9.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0z4h04mbkzqgpk698bac6f50jxkf02ils6khzl7zbw7yvi6gkkc8";
  };

  propagatedBuildInputs = [
    click
    h11
    httptools
    uvloop
    websockets
    wsproto
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "h11==0.8.*" "h11"
  '';

  checkInputs = [ pytest requests ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = https://www.uvicorn.org/;
    description = "The lightning-fast ASGI server";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
