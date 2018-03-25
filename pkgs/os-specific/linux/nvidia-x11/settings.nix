nvidia_x11: sha256:

{ stdenv, lib, fetchurl, pkgconfig, m4, jansson, gtk2, dbus, gtk3, libXv, libXrandr, libXext, libXxf86vm, libvdpau
, librsvg, wrapGAppsHook
, withGtk2 ? false, withGtk3 ? true
}:

let
  src = fetchurl {
    url = "https://download.nvidia.com/XFree86/nvidia-settings/nvidia-settings-${nvidia_x11.version}.tar.bz2";
    inherit sha256;
  };

  libXNVCtrl = stdenv.mkDerivation {
    name = "libXNVCtrl-${nvidia_x11.version}";
    inherit (nvidia_x11) version;
    inherit src;

    buildInputs = [ libXrandr libXext ];

    preBuild = ''
      cd src/libXNVCtrl
    '';

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/include/NVCtrl

      cp libXNVCtrl.a $out/lib
      cp NVCtrl.h     $out/include/NVCtrl
      cp NVCtrlLib.h  $out/include/NVCtrl
    '';
  };

in

stdenv.mkDerivation rec {
  name = "nvidia-settings-${nvidia_x11.version}";
  inherit (nvidia_x11) version;
  inherit src;

  nativeBuildInputs = [ pkgconfig m4 ];

  buildInputs = [ jansson libXv libXrandr libXext libXxf86vm libvdpau nvidia_x11 gtk2 dbus ]
             ++ lib.optionals withGtk3 [ gtk3 librsvg wrapGAppsHook ];

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
    homepage = http://www.nvidia.com/object/unix.html;
    description = "Settings application for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
