{ stdenv, fetchurl, binutilsCross ? null, gccCross ? null
, onlyHeaders ? false
, onlyPthreads ? false
}:

let
  name = "mingw-w64-${version}";
  version = "3.3.0";
in
stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    sha256 = "1vzw86vg02h0yq8f4fhxdpf79h3k3il7nvj5n1igbbgrcnm4sxj4";
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
