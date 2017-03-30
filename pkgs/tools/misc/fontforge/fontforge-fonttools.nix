{stdenv, fontforge, zlib}:
stdenv.mkDerivation rec {
  name = "fontforge-fonttools-${fontforge.version}";
  src = fontforge.src;

  buildInputs = [zlib];

  setSourceRoot = ''export sourceRoot="$(echo */contrib/fonttools)"'';

  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/fontforge-fonttools}
    for i in *.c; do
      gcc "$i" -lz -lm --std=c99 -o "$out"/bin/$(basename "$i" .c)
    done
    cp README* "$out/share/doc/fontforge-fonttools"
  '';

  meta = with stdenv.lib; {
    description = ''Small font tools shipped in FontForge contrib'';
    license = fontforge.meta.license;
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; unix;
  };
}
