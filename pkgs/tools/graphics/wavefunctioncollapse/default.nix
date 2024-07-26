{lib, stdenv, fetchFromGitHub, mono}:
stdenv.mkDerivation rec {
  pname = "wavefunctioncollapse";
  version = "0.0pre20170130";
  src = fetchFromGitHub {
    owner = "mxgmn";
    repo = "WaveFunctionCollapse";
    rev = "ef660c037b1d7c4ebce66efc625af2bb2f2111c0";
    sha256 = "1dr5fvdgn1jqqacby6rrqm951adx3jw0j70r5i8pmrqnnw482l8m";
  };
  buildPhase = ''
    mcs *.cs -out:wavefunctioncollapse.exe -r:System.Drawing
    grep -m1 -B999 '^[*][/]' Main.cs > COPYING.MIT
  '';
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/wavefunctioncollapse,share/wavefunctioncollapse}
    cp README.md COPYING.MIT "$out"/share/doc/wavefunctioncollapse
    cp wavefunctioncollapse.exe "$out"/bin
    cp -r [Ss]amples samples.xml "$out/share/wavefunctioncollapse"

    echo "#! ${stdenv.shell}" >> "$out/bin/wavefunctioncollapse"
    echo "chmod u+w ." >> "$out/bin/wavefunctioncollapse"
    echo "'${mono}/bin/mono' '$out/bin/wavefunctioncollapse.exe' \"\$@\"" >>  "$out/bin/wavefunctioncollapse"
    chmod a+x "$out/bin/wavefunctioncollapse"
  '';
  buildInputs = [mono];
  meta = {
    description = "A generator of bitmaps that are locally similar to the input bitmap";
    license = lib.licenses.mit;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
