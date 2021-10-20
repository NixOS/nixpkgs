{ lib, buildDotnetModule, fetchFromGitHub, makeDesktopItem
, libX11, libgdiplus, ffmpeg
, SDL2_mixer, openal, libsoundio, sndio, pulseaudio
, gtk3, gobject-introspection, gdk-pixbuf, wrapGAppsHook
}:

buildDotnetModule rec {
  pname = "ryujinx";
  version = "1.0.7065"; # Versioning is based off of the official appveyor builds: https://ci.appveyor.com/project/gdkchan/ryujinx

  src = fetchFromGitHub {
    owner = "Ryujinx";
    repo = "Ryujinx";
    rev = "c54a14d0b8d445d9d0074861dca816cc801e4008";
    sha256 = "13j91413x1bvg27vcx9sgc7gv00q84d8f5pllih5g5plzld4r541";
  };

  projectFile = "Ryujinx.sln";
  executables = [ "Ryujinx" ];
  nugetDeps = ./deps.nix;

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection gdk-pixbuf ];
  runtimeDeps = [
    gtk3
    libX11
    libgdiplus
    ffmpeg
    SDL2_mixer
    openal
    libsoundio
    sndio
    pulseaudio
  ];

  patches = [
    ./log.patch # Without this, Ryujinx attempts to write logs to the nix store. This patch makes it write to "~/.config/Ryujinx/Logs" on Linux.
  ];

  preInstall = ''
    # TODO: fix this hack https://github.com/Ryujinx/Ryujinx/issues/2349
    mkdir -p $out/lib/sndio-6
    ln -s ${sndio}/lib/libsndio.so $out/lib/sndio-6/libsndio.so.6

    makeWrapperArgs+=(
      --suffix LD_LIBRARY_PATH : "$out/lib/sndio-6"
    )

    for i in 16 32 48 64 96 128 256 512 1024; do
      install -D ${src}/Ryujinx/Ui/Resources/Logo_Ryujinx.png $out/share/icons/hicolor/''${i}x$i/apps/ryujinx.png
    done

    cp -r ${makeDesktopItem {
      desktopName = "Ryujinx";
      name = "ryujinx";
      exec = "Ryujinx";
      icon = "ryujinx";
      comment = meta.description;
      type = "Application";
      categories = "Game;";
    }}/share/applications $out/share
  '';

  meta = with lib; {
    description = "Experimental Nintendo Switch Emulator written in C#";
    homepage = "https://ryujinx.org/";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
  };
  passthru.updateScript = ./updater.sh;
}
