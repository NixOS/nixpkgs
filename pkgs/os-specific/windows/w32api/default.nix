{stdenv, fetchurl, binutilsCross ? null, gccCross ? null, onlyHeaders ? false}:

let
  name = "w32api-3.14";
in
stdenv.mkDerivation ({
  inherit name;
 
  src = fetchurl {
    url = "mirror://sourceforge/mingw/${name}-mingw32-src.tar.gz";
    sha256 = "128ax8a4dlspxsi5fi7bi1aslppqx3kczr1ibzj1z1az48bvwp21";
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
