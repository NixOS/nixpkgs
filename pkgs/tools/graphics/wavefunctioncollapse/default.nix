{stdenv, fetchFromGitHub, mono}:
stdenv.mkDerivation rec {
  name = "wavefunctioncollapse-${version}";
  version = "0.0pre20160930";
  src = fetchFromGitHub {
    owner = "mxgmn";
    repo = "WaveFunctionCollapse";
    rev = "333f592b6612da43ec475c988c09325378c662e9";
    sha256 = "1cpwn52ka1zsi2yc7rfg5r9ll2kjgzabx4a5axcp9c4ph5qzsza6";
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
    inherit version;
    description = ''A generator of bitmaps that are locally similar to the input bitmap'';
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
