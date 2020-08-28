{ stdenv
, buildPythonPackage
, fetchPypi
, xorg
, cffi
, nose
, six
}:

buildPythonPackage rec {
  version = "0.10.1";
  pname = "xcffib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cab1630a51076b11819c97e6da461ddd4cb21bdf65c071d1c57a846c9b129c12";
  };

  patchPhase = ''
    # Hardcode cairo library path
    sed -e 's,ffi\.dlopen(,&"${xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
  '';

  propagatedBuildInputs = [ cffi six ];

  checkInputs = [ nose ];

  pythonImportsCheck = [ "xcffib" ];

  meta = with stdenv.lib; {
    description = "A drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamilchm ];
  };
}
