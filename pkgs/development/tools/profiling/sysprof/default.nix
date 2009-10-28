{ fetchurl, stdenv, kernel, binutils
, pkgconfig, gtk, glib, pango, libglade }:

stdenv.mkDerivation rec {
  name = "sysprof-1.0.10-${kernel.version}";

  src = fetchurl {
    url = "http://www.daimi.au.dk/~sandmann/sysprof/${name}.tar.gz";
    sha256 = "1cdjnymd9nz72vcw6j0bbhb2ka19rjqd3scgx810a4m3qcai7irs";
  };

  buildInputs = [ binutils pkgconfig gtk glib pango libglade ];

  patches = [ ./configure.patch ];

  preConfigure = ''
    kernelVersion=$(cd "${kernel}/lib/modules" && echo *)
    echo "assuming Linux kernel version \`$kernelVersion'"

    sed -i "module/Makefile" \
        -e"s|^[[:blank:]]*KDIR[[:blank:]]*:=.*$|KDIR := ${kernel}/lib/modules/$kernelVersion/build|g ;
	   s|\$(KMAKE) modules_install|install sysprof-module.ko $out/share/sysprof/module|g ;
	   s|\\[ -e /sbin/depmod.*$|true|g"

    # XXX: We won't run `depmod' after installing the module.
  '';

  configureFlags = "--enable-kernel-module";

  preInstall = ''
    mkdir -p "$out/share/sysprof/module"
  '';

  meta = {
    homepage = http://www.daimi.au.dk/~sandmann/sysprof/;
    description = "Sysprof, a system-wide profiler for Linux";
    license = "GPLv2+";

    longDescription = ''
      Sysprof is a sampling CPU profiler for Linux that uses a kernel
      module to profile the entire system, not just a single
      application.  Sysprof handles shared libraries and applications
      do not need to be recompiled.  In fact they don't even have to
      be restarted.
    '';
  };
}