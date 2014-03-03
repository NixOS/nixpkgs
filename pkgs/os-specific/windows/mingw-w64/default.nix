{ stdenv, fetchurl, binutilsCross ? null, gccCross ? null
, onlyHeaders ? false
, onlyPthreads ? false
}:

let
  name = "mingw-w64-3.1.0";
in
stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v3.1.0.tar.bz2";
    sha256 = "1lhpw381gc59w8b1r9zzdwa9cdi2wx6qx7s6rvajapmbw7ksgrzc";
  };
} //
(if onlyHeaders then {
  name = name + "-headers";
  preConfigure = ''
    cd mingw-w64-headers
  '';
  configureFlags = "--without-crt";
} else if onlyPthreads then {
  name = name + "-pthreads";
  preConfigure = ''
    cd mingw-w64-libraries/winpthreads
  '';
} else {
  buildInputs = [ gccCross binutilsCross ];

  crossConfig = gccCross.crossConfig;

  dontStrip = true;
})
)
