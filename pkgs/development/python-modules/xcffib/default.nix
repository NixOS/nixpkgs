{ stdenv
, buildPythonPackage
, fetchPypi
, xorg
, cffi
, six
}:

buildPythonPackage rec {
  version = "0.8.1";
  pname = "xcffib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03nf3xrqq25sj9phqc9ngvqxrrp14s4ifsx9hv41kp7zi3xamsfn";
  };

  patchPhase = ''
    # Hardcode cairo library path
    sed -e 's,ffi\.dlopen(,&"${xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
  '';

  propagatedBuildInputs = [ cffi six ];

  meta = with stdenv.lib; {
    description = "A drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamilchm ];
  };
}
