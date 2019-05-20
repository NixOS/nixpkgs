{ stdenv, fetchFromGitHub, SDL }:

stdenv.mkDerivation rec {
  pname = "azimuth";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner  = "mdsteele";
    repo   = "azimuth";
    rev    = "v${version}";
    sha256 = "0yh52i3vfmj5zd7fs1r2xpjy2mknycr5xz6kyixj2qncb25xsm7z";
  };

  preConfigure = ''
    substituteInPlace data/azimuth.desktop \
      --replace Exec=azimuth "Exec=$out/bin/azimuth" \
      --replace "Version=%AZ_VERSION_NUMBER" "Version=${version}"
  '';

  makeFlags = [
    "BUILDTYPE=release"
  ];

  buildInputs = [ SDL ];

  enableParallelBuilding = true;

  # the game doesn't have an installation procedure
  installPhase = ''
    mkdir -p $out/bin
    cp out/release/host/bin/azimuth $out/bin/azimuth
    cp out/release/host/bin/editor $out/bin/azimuth-editor
    cp out/release/host/bin/muse $out/bin/azimuth-muse
    cp out/release/host/bin/zfxr $out/bin/azimuth-zfxr
    mkdir -p $out/share/doc/azimuth
    cp doc/* README.md LICENSE $out/share/doc/azimuth
    mkdir -p $out/share/icons/hicolor/128x128/apps $out/share/icons/hicolor/64x64/apps $out/share/icons/hicolor/48x48/apps $out/share/icons/hicolor/32x32/apps
    cp data/icons/icon_128x128.png $out/share/icons/hicolor/128x128/apps/azimuth.png
    cp data/icons/icon_64x64.png $out/share/icons/hicolor/64x64/apps/azimuth.png
    cp data/icons/icon_48x48.png $out/share/icons/hicolor/48x48/apps/azimuth.png
    cp data/icons/icon_32x32.png $out/share/icons/hicolor/32x32/apps/azimuth.png
    mkdir -p $out/share/applications
    cp data/azimuth.desktop $out/share/applications
  '';

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

    license = stdenv.lib.licenses.gpl3Plus;
    homepage = https://mdsteele.games/azimuth/index.html;
    maintainers = with stdenv.lib.maintainers; [ marius851000 ];
    platforms = stdenv.lib.platforms.linux;
  };

}
