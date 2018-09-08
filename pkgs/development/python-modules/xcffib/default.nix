{ stdenv
, buildPythonPackage
, fetchPypi
, xorg
, cffi
, six
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "xcffib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36142cb72535933e8e1ed39ff2c45559fa7038823bd6be6961ef8ee5bb0f6912";
  };

  patchPhase = ''
    # Hardcode cairo library path
    sed -e 's,ffi\.dlopen(,&"${xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
  '';

  propagatedBuildInputs = [ cffi six ];

  meta = with stdenv.lib; {
    description = "A drop in replacement for xpyb, an XCB python binding";
    homepage = https://github.com/tych0/xcffib;
    license = licenses.asl20;
    maintainers = with maintainers; [ kamilchm ];
  };
}
