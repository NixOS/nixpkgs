{ stdenv, fetchurl, kernelDev ? null, xlibs, zlib, perl
, gtk, atk, pango, glib, gdk_pixbuf
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

let

  versionNumber = "319.32";
  kernel310patch = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/nvidia-linux-3.10.patch?h=packages/nvidia";
    sha256 = "0nhzg6jdk9sf1vzj519gqi8a2n9xydhz2bcz472pss2cfgbc1ahb";
  };

in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}${optionalString (!libsOnly) "-${kernelDev.version}"}";

  builder = ./builder.sh;

  patches =
    [ ./version-test.patch ]
    ++ optional (!versionOlder kernelDev.version "3.10") kernel310patch;

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}.run";
        sha256 = "02rjiizgb9mgal0qrklzjvfzybv139yv6za8xp045k7qdyqvsqzf";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-no-compat32.run";
        sha256 = "18268q3pa6v4ygfnlm888jmp84dmg1w9c323cr51pn5jg54vygcm";
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
