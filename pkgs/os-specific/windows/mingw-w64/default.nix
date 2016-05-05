{ stdenv, fetchurl, binutilsCross ? null, gccCross ? null
, onlyHeaders ? false
, onlyPthreads ? false
}:

let
  version = "4.0.6";
  name = "mingw-w64-${version}";
in
stdenv.mkDerivation ({
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    sha256 = "0p01vm5kx1ixc08402z94g1alip4vx66gjpvyi9maqyqn2a76h0c";
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
