{stdenv, fetchurl, binutilsCross ? null, gccCross ? null, onlyHeaders ? false}:

let
  name = "mingwrt-3.18";
in
stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/mingw/${name}-mingw32-src.tar.gz";
    sha256 = "0hmxgkxnf6an70g07gmyik46sw1qm204izh6sp923szddvypjjfy";
  };

} //
(if onlyHeaders then {
  name = name + "-headers";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    ensureDir $out
    cp -R include $out
  '';
} else {
  buildInputs = [ gccCross binutilsCross ];

  crossConfig = gccCross.crossConfig;

  dontStrip = true;
})
)
