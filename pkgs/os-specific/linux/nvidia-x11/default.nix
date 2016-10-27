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

  versionNumber = "367.57";

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
        sha256 = "1fw87nvbf8dmy7clwmm7jwp842c78mkz9bcb060wbihsywkfkm23";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}.run";
        sha256 = "0lc87bgr29l9idhy2a4bsplkwx9r0dz9kjhcc5xq2xqkkyr5sqd1";
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
