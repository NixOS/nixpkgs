{ stdenv, fetchurl, kernelDev ? null, xlibs, zlib, perl
, gtk, atk, pango, glib, gdk_pixbuf
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

let versionNumber = "313.30"; in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}${optionalString (!libsOnly) "-${kernelDev.version}"}";

  builder = ./builder.sh;

  patches = [ ./version-test.patch ];

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}.run";
        sha256 = "1ba9mphvynni44dv3mwx9a9819drmrc4n82f4i58xjhvkfbi03qa";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-no-compat32.run";
        sha256 = "1ggd3raxax99xnbphf945f0ggj5kq30jnknhyqy2fha9is1jbnjp";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber libsOnly;

  kernel = if libsOnly then null else kernelDev;

  dontStrip = true;

  glPath = stdenv.lib.makeLibraryPath [xlibs.libXext xlibs.libX11 xlibs.libXrandr];

  cudaPath = stdenv.lib.makeLibraryPath [zlib stdenv.gcc.gcc];

  openclPath = stdenv.lib.makeLibraryPath [zlib];

  programPath = optionalString (!libsOnly) (stdenv.lib.makeLibraryPath
    [ gtk atk pango glib gdk_pixbuf xlibs.libXv ] );

  buildInputs = [ perl ];

  meta = {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for NVIDIA graphics cards";
    license = stdenv.lib.licenses.unfreeRedistributable;
  };
}
