{lib, stdenv, fetchFromGitHub, mono}:
stdenv.mkDerivation rec {
  pname = "syntex";
  version = "0.0pre20160915";
  src = fetchFromGitHub {
    owner = "mxgmn";
    repo = "SynTex";
    rev = "f499a7c8112be4a63eb44843ba72957c2c9a04db";
    sha256 = "13fz6frlxsdz8qq94fsvim27cd5klmdsax5109yxm9175vgvpa0a";
  };
  buildPhase = ''
    mcs *.cs -out:syntex.exe -r:System.Drawing
    grep -m1 -B999 '^[*][/]' SynTex.cs > COPYING.MIT
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/syntex,share/syntex}
    cp README.md COPYING.MIT "$out"/share/doc/syntex
    cp syntex.exe "$out"/bin
    cp -r [Ss]amples samples.xml "$out/share/syntex"

    echo "#! ${stdenv.shell}" >> "$out/bin/syntex"
    echo "chmod u+w ." >> "$out/bin/syntex"
    echo "'${mono}/bin/mono' '$out/bin/syntex.exe' \"\$@\"" >>  "$out/bin/syntex"
    chmod a+x "$out/bin/syntex"
  '';
  buildInputs = [mono];
  meta = {
    description = "Texture synthesis from examples";
    license = lib.licenses.mit;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
