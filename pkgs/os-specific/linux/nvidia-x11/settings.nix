nvidia_x11: sha256:

{ stdenv, lib, fetchFromGitHub, pkgconfig, m4, jansson, gtk2, dbus, gtk3, libXv, libXrandr, libXext, libXxf86vm, libvdpau
, librsvg, wrapGAppsHook
, withGtk2 ? false, withGtk3 ? true
}:

let
  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-settings";
    rev = nvidia_x11.version;
    inherit sha256;
  };

  libXNVCtrl = stdenv.mkDerivation {
    pname = "libXNVCtrl";
    inherit (nvidia_x11) version;
    inherit src;

    buildInputs = [ libXrandr libXext ];

    preBuild = ''
      cd src/libXNVCtrl
    '';

    makeFlags = [
      "OUTPUTDIR=." # src/libXNVCtrl
    ];

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/include/NVCtrl

      cp libXNVCtrl.a $out/lib
      cp NVCtrl.h     $out/include/NVCtrl
      cp NVCtrlLib.h  $out/include/NVCtrl
    '';
  };

in

stdenv.mkDerivation {
  pname = "nvidia-settings";
  inherit (nvidia_x11) version;
  inherit src;

  nativeBuildInputs = [ pkgconfig m4 ];

  buildInputs = [ jansson libXv libXrandr libXext libXxf86vm libvdpau nvidia_x11 gtk2 dbus ]
             ++ lib.optionals withGtk3 [ gtk3 librsvg wrapGAppsHook ];

  enableParallelBuilding = true;
  makeFlags = [ "NV_USE_BUNDLED_LIBJANSSON=0" ];
  installFlags = [ "PREFIX=$(out)" ];

  postPatch = lib.optionalString nvidia_x11.useProfiles ''
    sed -i 's,/usr/share/nvidia/,${nvidia_x11.bin}/share/nvidia/,g' src/gtk+-2.x/ctkappprofile.c
  '';

  preBuild = ''
    if [ -e src/libXNVCtrl/libXNVCtrl.a ]; then
      ( cd src/libXNVCtrl
        make
      )
    fi
  '';

  postInstall = ''
    ${lib.optionalString (!withGtk2) ''
      rm -f $out/lib/libnvidia-gtk2.so.*
    ''}
    ${lib.optionalString (!withGtk3) ''
      rm -f $out/lib/libnvidia-gtk3.so.*
    ''}

    # Install the desktop file and icon.
    # The template has substitution variables intended to be replaced resulting
    # in absolute paths. Because absolute paths break after the desktop file is
    # copied by a desktop environment, make Exec and Icon be just a name.
    sed -i doc/nvidia-settings.desktop \
      -e "s|^Exec=.*$|Exec=nvidia-settings|" \
      -e "s|^Icon=.*$|Icon=nvidia-settings|" \
      -e "s|__NVIDIA_SETTINGS_DESKTOP_CATEGORIES__|Settings|g"
    install doc/nvidia-settings.desktop -D -t $out/share/applications/
    install doc/nvidia-settings.png -D -t $out/share/icons/hicolor/128x128/apps/
  '';

  binaryName = if withGtk3 then ".nvidia-settings-wrapped" else "nvidia-settings";

  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/$binaryName):$out/lib:${libXv}/lib" \
      $out/bin/$binaryName
  '';

  passthru = {
    inherit libXNVCtrl;
  };

  meta = with stdenv.lib; {
    homepage = https://www.nvidia.com/object/unix.html;
    description = "Settings application for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = nvidia_x11.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
