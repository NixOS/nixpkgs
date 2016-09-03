{ stdenv, fetchurl, kernel ? null, xorg, zlib, perl
, gtk, atk, pango, glib, gdk_pixbuf
, # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
  libsOnly ? false
}:

with stdenv.lib;

let versionNumber = "304.131"; in

stdenv.mkDerivation {
  name = "nvidia-x11-${versionNumber}${optionalString (!libsOnly) "-${kernel.version}"}";

  builder = ./builder-legacy304.sh;

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://download.nvidia.com/XFree86/Linux-x86/${versionNumber}/NVIDIA-Linux-x86-${versionNumber}.run";
        sha256 = "1a1d0fsahgijcvs2p59vwhs0dpp7pp2wmvgcs1i7fzl6yyv4nmfj";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}-no-compat32.run";
        sha256 = "0gpqzb5gvhrcgrp3kph1p0yjkndx9wfzgh5j88ysrlflkv3q4vig";
      }
    else throw "nvidia-x11 does not support platform ${stdenv.system}";

  inherit versionNumber libsOnly;

  kernel = if libsOnly then null else kernel.dev;

  hardeningDisable = [ "pic" "format" ];

  dontStrip = true;

  glPath = stdenv.lib.makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr];

  cudaPath = stdenv.lib.makeLibraryPath [zlib stdenv.cc.cc];

  programPath = optionalString (!libsOnly) (stdenv.lib.makeLibraryPath
    [ gtk atk pango glib gdk_pixbuf xorg.libXv ] );

  buildInputs = [ perl ];

  meta = {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for NVIDIA graphics cards";
    license = stdenv.lib.licenses.unfree;
  };
}
