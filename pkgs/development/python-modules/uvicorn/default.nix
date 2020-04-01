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
  version = "0.11.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "145c569j4511zw3wglyv9qgd7g1757ypi2blcckpcmahqw11l5p2";
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

  # LICENCE.md gets propagated without this, causing collisions
  # see https://github.com/encode/uvicorn/issues/392
  postInstall = ''
    rm $out/LICENSE.md
  '';

  meta = with lib; {
    homepage = https://www.uvicorn.org/;
    description = "The lightning-fast ASGI server";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
