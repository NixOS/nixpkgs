{stdenv, fetchFromGitHub, zlib}:

stdenv.mkDerivation rec {
  version = "20160404";
  name = "fontforge-fonttools-${version}";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "fontforge";
    rev = version;
    sha256 = "15nacq84n9gvlzp3slpmfrrbh57kfb6lbdlc46i7aqgci4qv6fg0";
  };

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
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; unix;
  };
}
