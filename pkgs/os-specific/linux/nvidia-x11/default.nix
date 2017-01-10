{ stdenv, fetchurl, kernel ? null, xorg, zlib, perl
, gtk2, atk, pango, glib, gdk_pixbuf, cairo, nukeReferences
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

assert (!libsOnly) -> kernel != null;

let

  versionNumber = "375.26";

  # Policy: use the highest stable version as the default (on our master).
  inherit (stdenv.lib) makeLibraryPath;

  nameSuffix = optionalString (!libsOnly) "-${kernel.version}";

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}${nameSuffix}";

  builder = ./builder.sh;

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}.run";
        sha256 = "0yv19rkz2wzzj0fygfjb1mh21iy769kff3yg2kzk8bsiwnmcyybw";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}.run";
        sha256 = "1kqy9ayja3g5znj2hzx8pklz8qi0b0l9da7c3ldg3hlxf31v4hjg";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber libsOnly;
  inherit (stdenv) system;

  kernel = if libsOnly then null else kernel.dev;

  hardeningDisable = [ "pic" "format" ];

  dontStrip = true;

  glPath      = makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr];
  cudaPath    = makeLibraryPath [zlib stdenv.cc.cc];
  openclPath  = makeLibraryPath [zlib];
  allLibPath  = makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr zlib stdenv.cc.cc];

  gtkPath = optionalString (!libsOnly) (makeLibraryPath
    [ gtk2 atk pango glib gdk_pixbuf cairo ] );
  programPath = makeLibraryPath [ xorg.libXv ];



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
