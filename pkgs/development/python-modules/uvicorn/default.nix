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
  version = "0.11.5";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0cf0vw6kzxwlkvk5gw85wv3kg1kdil0wkq3s7rmxpvrk6gjk8jvq";
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
      --replace "h11==0.8.*" "h11" \
      --replace "httptools==0.0.13" "httptools"
  '';

  checkInputs = [ pytest requests ];
  # watchgod required the watchgod package, which isn't available in nixpkgs
  checkPhase = ''
    pytest --ignore=tests/supervisors/test_watchgodreload.py
  '';

  meta = with lib; {
    homepage = "https://www.uvicorn.org/";
    description = "The lightning-fast ASGI server";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
