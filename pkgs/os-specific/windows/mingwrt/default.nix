{stdenv, fetchurl, binutils ? null, gccCross ? null, onlyHeaders ? false}:

let
  name = "mingwrt-3.20";
in
stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/mingw/MinGW/Base/mingw-rt/${name}-mingw32-src.tar.gz";
    sha256 = "02pydg1m8y35nxb4k34nlb5c341y2waq76z42mgdzlcf661r91pi";
  };

} //
(if onlyHeaders then {
  name = name + "-headers";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p $out
    cp -R include $out
  '';
} else {
  buildInputs = [ gccCross binutils ];

  crossConfig = gccCross.crossConfig;

  dontStrip = true;
})
)
