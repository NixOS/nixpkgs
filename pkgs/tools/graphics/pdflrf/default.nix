{stdenv, fetchurl, expat, freetype, fontconfig, libstdcpp5}:

stdenv.mkDerivation ( rec {
  name = "pdflrf-0.99";

  src = fetchurl {
    # I got it from http://www.mobileread.com/forums/showthread.php?t=13135
    # But that needs user registration to allow downloading.
    # I unpacked the executable (upx) to allow patchelf to manage it
    # Temporary place:
    url = http://vicerveza.homeunix.net/~viric/soft/pdflrf-linux-0.99.bz2;
    sha256 = "faf8c68b586d367e227581294a4dc22b2865291446d40b72d70b4dd53f7088d4";
  };

  buildInputs = [ expat freetype fontconfig libstdcpp5 ];

  phases = "unpackPhase patchPhase installPhase";

  unpackPhase = "bunzip2 -c $src > pdflrf ; chmod +x pdflrf";

  patchPhase = ''
    set -x
    fullPath=
    for i in $buildInputs; do
      fullPath=$fullPath:$i/lib
    done

    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath $fullPath pdflrf
  '';

  installPhase = "ensureDir $out/bin; cp pdflrf $out/bin";

  meta = {
      description = "PDF to LRF converter (Sony Portable Reader System format)";
      homepage = http://www.mobileread.com/forums/showthread.php?t=13135;
      # The program comes as binary-only, but free to use.
      license = "free";
  };
})
