{
  lib,
  stdenv,
  fetchurl,
  warsow-engine,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "warsow";
  version = "2.1.2";

  src = fetchurl {
    url = "http://warsow.net/${pname}-${version}.tar.gz";
    sha256 = "07y2airw5qg3s1bf1c63a6snjj22riz0mqhk62jmfm9nrarhavrc";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/warsow
    cp -r basewsw $out/share/warsow
    ln -s ${warsow-engine}/lib/warsow $out/share/warsow/libs

    mkdir -p $out/bin
    for i in ${warsow-engine}/bin/*; do
      makeWrapper "$i" "$out/bin/$(basename "$i")" --chdir "$out/share/warsow"
    done
  '';

  meta = with lib; {
    description = "Multiplayer FPS game designed for competitive gaming";
    longDescription = ''
      Set in a futuristic cartoon-like world where rocketlauncher-wielding
      pigs and lasergun-carrying cyberpunks roam the streets, Warsow is a
      completely free fast-paced first-person shooter (FPS) for Windows, Linux
      and macOS.
    '';
    homepage = "http://www.warsow.net";
    license = licenses.unfreeRedistributable;
    maintainers = [
    ];
    platforms = warsow-engine.meta.platforms;
  };
}
