{ stdenv, fetchurl, xz, binutils ? null
, gccCross ? null, onlyHeaders ? false }:

let
  name = "w32api-3.17-2";
in
stdenv.mkDerivation ({
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/mingw/MinGW/Base/w32api/w32api-3.17/${name}-mingw32-src.tar.lzma";
    sha256 = "09rhnl6zikmdyb960im55jck0rdy5z9nlg3akx68ixn7khf3j8wb";
  };

  nativeBuildInputs = [ xz ];

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
