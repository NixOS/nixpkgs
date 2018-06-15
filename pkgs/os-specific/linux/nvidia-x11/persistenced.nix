nvidia_x11: sha256:

{ stdenv, lib, fetchurl, m4 }:

stdenv.mkDerivation rec {
  name = "nvidia-persistenced-${nvidia_x11.version}";
  inherit (nvidia_x11) version;

  src = fetchurl {
    url = "https://download.nvidia.com/XFree86/nvidia-persistenced/${name}.tar.bz2";
    inherit sha256;
  };

  nativeBuildInputs = [ m4 ];

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/nvidia-persistenced):${nvidia_x11}/lib" \
      $out/bin/nvidia-persistenced
  '';

  meta = with stdenv.lib; {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "Settings application for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = nvidia_x11.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
