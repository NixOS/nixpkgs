{ stdenv, lib, fetchFromGitHub, fetchpatch
, haxe, haxePackages, neko, makeWrapper, imagemagick
, alsa-lib, libpulseaudio, libGL, libX11, libXdmcp, libXext, libXi, libXinerama, libXrandr
, makeDesktopItem
}:

let
  desktopItem = makeDesktopItem {
    name = "funkin";
    exec = "Funkin";
    desktopName = "Friday Night Funkin";
    categories = ["Game" "ArcadeGame"];
    icon = "funkin";
  };
in
stdenv.mkDerivation rec {
  pname = "funkin";
  version = "unstable-2021-04-02";

  src = fetchFromGitHub {
    owner = "ninjamuffin99";
    repo = "Funkin";
    rev = "f94dece4a40d977c8a501b55ed9b9b3ee4344e13";
    sha256 = "sha256-WaNihorg5SvKPUl8/PO0w1NMXrRDPxZry+K7n+tLA1A=";
  };

  patches = [
    # TODO remove when fix pushed
    # Fixes Freeplay crash on master
    (fetchpatch {
      url = "https://github.com/ninjamuffin99/Funkin/pull/412/commits/af62bdca4d70e06ea8b383ab5c9c6b3f5d8f087b.patch";
      sha256 = "1p9vzm7hkay8fzrd82hgrnafd0g5qi34brzv0hyjirryhni840fy";
    })
    # Fixes bugged version outdated version
    (fetchpatch {
      name = "fix-the-update-check.patch";
      url = "https://github.com/ninjamuffin99/Funkin/pull/941/commits/996c9b6d89bf4447b1f39390bb6e8fb7d6a8c37c.patch";
      sha256 = "1m5b47y2pbdwdk5dsvgivq8705cz95n8imdckyg3r9jazhkrvh6k";
    })
    # Fix link opening
    (fetchpatch {
      name = "Makes-the-donation-button-actually-work-on-Linux.patch";
      url = "https://github.com/ninjamuffin99/Funkin/pull/172.patch";
      sha256 = "1491fw52j5am5bg02v05y82njbdj1aqqdidxz36i4g6kcdy2x2iz";
    })
  ];

  postPatch = ''
    # Real API keys are stripped from repo
    cat >source/APIStuff.hx <<EOF
    package;

    class APIStuff
    {
      public static var API:String = "";
      public static var EncKey:String = "";
    }
    EOF
  '';

  nativeBuildInputs = [ haxe neko makeWrapper imagemagick ]
  ++ (with haxePackages; [
    hxcpp
    hscript
    openfl
    lime
    flixel
    flixel-addons
    flixel-ui
    newgrounds
    polymod
    discord_rpc
  ]);

  buildInputs = [ alsa-lib libpulseaudio libGL libX11 libXdmcp libXext libXi libXinerama libXrandr ];

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    export HOME=$PWD
    haxelib run lime build linux -final

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/funkin}
    cp -R export/release/linux/bin/* $out/lib/funkin/
    for so in $out/lib/funkin/{Funkin,lime.ndll}; do
      $STRIP -s $so
    done
    wrapProgram $out/lib/funkin/Funkin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --run "cd $out/lib/funkin"
    ln -s $out/{lib/funkin,bin}/Funkin
    # desktop file
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications

    # icons
    for i in 16 32 64; do
      install -D art/icon$i.png $out/share/icons/hicolor/''${i}x$i/funkin.png
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Friday Night Funkin'";
    longDescription = ''
      Uh oh! Your tryin to kiss ur hot girlfriend, but her MEAN and EVIL dad is
      trying to KILL you! He's an ex-rockstar, the only way to get to his
      heart? The power of music...

      WASD/ARROW KEYS IS CONTROLS

      - and + are volume control

      0 to Mute

      It's basically like DDR, press arrow when arrow over other arrow.
      And uhhh don't die.
    '';
    homepage = "https://ninja-muffin24.itch.io/funkin";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ marius851000 ];
    broken = stdenv.system != "x86_64-linux";
  };
}
