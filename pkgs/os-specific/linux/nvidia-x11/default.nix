{ stdenv, fetchurl, kernel ? null, xorg, zlib, perl
, gtk, atk, pango, glib, gdk_pixbuf, cairo, nukeReferences
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

assert (!libsOnly) -> kernel != null;

let

  versionNumber = "367.35";

  # Policy: use the highest stable version as the default (on our master).
  inherit (stdenv.lib) makeLibraryPath;

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}${optionalString (!libsOnly) "-${kernel.version}"}";

  builder = ./builder.sh;

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}.run";
        sha256 = "05g36bxcfk21ab8b0ay3zy21k5nd71468p9y1nbflx7ghpx25jrq";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-no-compat32.run";
        sha256 = "0m4k8f0212l63h22wk6hgi8fbfsgxqih5mizsw4ixqqmjd75av4a";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber libsOnly;
  inherit (stdenv) system;

  kernel = if libsOnly then null else kernel.dev;

  dontStrip = true;

  glPath      = makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr];
  cudaPath    = makeLibraryPath [zlib stdenv.cc.cc];
  openclPath  = makeLibraryPath [zlib];
  allLibPath  = makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr zlib stdenv.cc.cc];

  gtkPath = optionalString (!libsOnly) (makeLibraryPath
    [ gtk atk pango glib gdk_pixbuf cairo ] );
  programPath = makeLibraryPath [ xorg.libXv ];

  patches = if (!libsOnly) && (versionAtLeast kernel.dev.version "4.7") then [ ./365.35-kernel-4.7.patch ] else [];

  buildInputs = [ perl nukeReferences ];

  disallowedReferences = if libsOnly then [] else [ kernel.dev ];

  meta = with stdenv.lib.meta; {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
    priority = 4; # resolves collision with xorg-server's "lib/xorg/modules/extensions/libglx.so"
  };
}
