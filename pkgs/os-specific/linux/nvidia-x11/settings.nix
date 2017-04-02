nvidia_x11: sha256:

{ stdenv, lib, fetchurl, pkgconfig, m4, jansson, gtk2, gtk3, libXv, libXrandr, libvdpau
, librsvg, wrapGAppsHook
, withGtk2 ? false, withGtk3 ? true
}:

stdenv.mkDerivation rec {
  name = "nvidia-settings-${nvidia_x11.version}";
  inherit (nvidia_x11) version;

  src = fetchurl {
    url = "ftp://download.nvidia.com/XFree86/nvidia-settings/${name}.tar.bz2";
    inherit sha256;
  };

  nativeBuildInputs = [ pkgconfig m4 ];

  buildInputs = [ jansson libXv libXrandr libvdpau nvidia_x11 gtk2 ]
             ++ lib.optionals withGtk3 [ gtk3 librsvg wrapGAppsHook ];

  NIX_LDFLAGS = [ "-lvdpau" "-lXrandr" "-lXv" "-lnvidia-ml" ];

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
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/$binaryName):$out/lib" \
      $out/bin/$binaryName
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.nvidia.com/object/unix.html";
    description = "Settings application for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
