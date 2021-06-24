{ lib
, buildPythonPackage
, fetchPypi
, xorg
, cffi
, nose
, six
}:

buildPythonPackage rec {
  version = "0.11.1";
  pname = "xcffib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12949cfe2e68c806efd57596bb9bf3c151f399d4b53e15d1101b2e9baaa66f5a";
  };

  patchPhase = ''
    # Hardcode cairo library path
    sed -e 's,ffi\.dlopen(,&"${xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
  '';

  propagatedBuildInputs = [ cffi six ];

  checkInputs = [ nose ];

  pythonImportsCheck = [ "xcffib" ];

  meta = with lib; {
    description = "A drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamilchm ];
  };
}
