{ lib, stdenv, fetchFromGitHub, SDL, which, installTool ? false }:

stdenv.mkDerivation rec {
  pname = "azimuth";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner  = "mdsteele";
    repo   = "azimuth";
    rev    = "v${version}";
    sha256 = "1znfvpmqiixd977jv748glk5zc4cmhw5813zp81waj07r9b0828r";
  };

  nativeBuildInputs = [ which ];
  buildInputs = [ SDL ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=maybe-uninitialized" ];

  preConfigure = ''
    substituteInPlace data/azimuth.desktop \
      --replace Exec=azimuth "Exec=$out/bin/azimuth" \
      --replace "Version=%AZ_VERSION_NUMBER" "Version=${version}"
  '';

  makeFlags = [
    "BUILDTYPE=release"
    "INSTALLDIR=$(out)"
  ] ++ (if installTool then ["INSTALLTOOL=true"] else ["INSTALLTOOL=false"]);


  enableParallelBuilding = true;

  meta = {
    description = "A metroidvania game using only vectorial graphic";
    longDescription = ''
      Azimuth is a metroidvania game, and something of an homage to the previous
      greats of the genre (Super Metroid in particular). You will need to pilot
      your ship, explore the inside of the planet, fight enemies, overcome
      obstacles, and uncover the storyline piece by piece. Azimuth features a
      huge game world to explore, lots of little puzzles to solve, dozens of
      weapons and upgrades to find and use, and a wide variety of enemies and
      bosses to tangle with.
    '';

    license = lib.licenses.gpl3Plus;
    homepage = "https://mdsteele.games/azimuth/index.html";
    maintainers = with lib.maintainers; [ marius851000 ];
    platforms = lib.platforms.linux;
  };

}
