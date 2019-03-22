{ stdenv
, buildPythonPackage
, fetchPypi
, xorg
, cffi
, six
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "xcffib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12yc2r8967hknk829q1lbsw6b9z7qa25y8dx8kz6c9qnlc215vb8";
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
