nvidia_x11: sha256:

{ stdenv, lib, fetchurl, pkgconfig, m4, gtk2, gtk3, libXv, libvdpau
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

  buildInputs = [ gtk2 gtk3 libXv libvdpau ];

  installFlags = [ "PREFIX=$(out)" ];

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

  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/nvidia-settings):$out/lib:${nvidia_x11}/lib" \
      $out/bin/nvidia-settings
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.nvidia.com/object/unix.html";
    description = "Settings application for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
