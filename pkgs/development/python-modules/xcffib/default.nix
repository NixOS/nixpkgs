{ lib, stdenv
, buildPythonPackage
, fetchPypi
, xorg
, cffi
, nose
, six
}:

buildPythonPackage rec {
  version = "0.11.0";
  pname = "xcffib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a751081d816a63d02a4c63f91fd9c0112c1e0061af7ccf79c4e7c18517a75406";
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
