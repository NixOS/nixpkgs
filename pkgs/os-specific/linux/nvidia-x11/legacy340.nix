{ stdenv, fetchurl, kernel ? null, xorg, zlib, perl
, gtk, atk, pango, glib, gdk_pixbuf
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

assert (!libsOnly) -> kernel != null;

let

  versionNumber = "340.96";
  /* This branch is needed for G8x, G9x, and GT2xx GPUs, and motherboard chipsets based on them.
    Ongoing support for new Linux kernels and X servers, as well as fixes for critical bugs,
    will be included in 340.* legacy releases through the end of 2019.
  */
  inherit (stdenv.lib) makeLibraryPath;
in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}${optionalString (!libsOnly) "-${kernel.version}"}";

  builder = ./builder-legacy340.sh;

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}.run";
        sha256 = "13j739gg1igll88xpfsx46m7pan4fwpzx5hqdskkdc0srmw2f3n4";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-no-compat32.run";
        sha256 = "1i0lri76ghhr4c6fdlv5gwzd99n70hv3kw21w51anb55msr9s3r8";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber libsOnly;

  kernel = if libsOnly then null else kernel.dev;

  dontStrip = true;

  glPath      = makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr];
  cudaPath    = makeLibraryPath [zlib stdenv.cc.cc];
  openclPath  = makeLibraryPath [zlib];
  allLibPath  = makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr zlib stdenv.cc.cc];

  programPath = optionalString (!libsOnly) (makeLibraryPath
    [ gtk atk pango glib gdk_pixbuf xorg.libXv ] );

  buildInputs = [ perl ];

  meta = with stdenv.lib.meta; {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
    priority = 4; # resolves collision with xorg-server's "lib/xorg/modules/extensions/libglx.so"
  };
}
