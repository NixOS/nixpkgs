{ stdenv, fetchurl, fetchzip, pkgconfig, SDL2, libpng, zlib, xz, freetype, fontconfig
, withOpenGFX ? true, withOpenSFX ? true, withOpenMSX ? true
, withFluidSynth ? true, audioDriver ? "alsa", fluidsynth, soundfont-fluid, procps
, writeScriptBin, makeWrapper, runtimeShell
}:

let
  opengfx = fetchzip {
    url = "https://cdn.openttd.org/opengfx-releases/0.6.0/opengfx-0.6.0-all.zip";
    sha256 = "1zg871j6kv7r0aqwca68d9kdf3smclgzan8hj76vj4fyfkykh173";
  };

  opensfx = fetchzip {
    url = "https://cdn.openttd.org/opensfx-releases/0.2.3/opensfx-0.2.3-all.zip";
    sha256 = "1bb167kszdd6dqbcdjrxxwab6b7y7jilhzi3qijdhprpm5gf1lp3";
  };

  openmsx = fetchzip {
    url = "https://cdn.openttd.org/openmsx-releases/0.3.1/openmsx-0.3.1-all.zip";
    sha256 = "0qnmfzz0v8vxrrvxnm7szphrlrlvhkwn3y92b4iy0b4b6yam0yd4";
  };

  playmidi = writeScriptBin "playmidi" ''
    #!${runtimeShell}
    trap "${procps}/bin/pkill fluidsynth" EXIT
    ${fluidsynth}/bin/fluidsynth -a ${audioDriver} -i ${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2 $*
  '';

in
stdenv.mkDerivation rec {
  pname = "openttd";
  version = "1.10.1";

  src = fetchurl {
    url = "https://cdn.openttd.org/openttd-releases/${version}/${pname}-${version}-source.tar.xz";
    sha256 = "0d22a3c50f7a321f4f211594f4987ac16c381e8e3e40f116848e63e91e7fbb9b";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ SDL2 libpng xz zlib freetype fontconfig ]
    ++ stdenv.lib.optionals withFluidSynth [ fluidsynth soundfont-fluid ];

  prefixKey = "--prefix-dir=";

  configureFlags = [
    "--without-liblzo2"
  ];

  makeFlags = [ "INSTALL_PERSONAL_DIR=" ];

  postInstall = ''
    mv $out/games/ $out/bin

    ${stdenv.lib.optionalString withOpenGFX ''
      cp ${opengfx}/* $out/share/games/openttd/baseset
    ''}

    mkdir -p $out/share/games/openttd/data

    ${stdenv.lib.optionalString withOpenSFX ''
      cp ${opensfx}/*.{obs,cat} $out/share/games/openttd/data
    ''}

    mkdir $out/share/games/openttd/baseset/openmsx

    ${stdenv.lib.optionalString withOpenMSX ''
      cp ${openmsx}/*.{obm,mid} $out/share/games/openttd/baseset/openmsx
    ''}

    ${stdenv.lib.optionalString withFluidSynth ''
      wrapProgram $out/bin/openttd \
        --add-flags -m \
        --add-flags extmidi:cmd=${playmidi}/bin/playmidi
    ''}
  '';

  meta = with stdenv.lib; {
    description = ''Open source clone of the Microprose game "Transport Tycoon Deluxe"'';
    longDescription = ''
      OpenTTD is a transportation economics simulator. In single player mode,
      players control a transportation business, and use rail, road, sea, and air
      transport to move goods and people around the simulated world.

      In multiplayer networked mode, players may:
        - play competitively as different businesses
        - play cooperatively controlling the same business
        - observe as spectators
    '';
    homepage = "https://www.openttd.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jcumming fpletz ];
  };
}
