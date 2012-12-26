{ stdenv, fetchurl, attr, zlib, SDL, alsaLib, pkgconfig, pciutils, libuuid, vde2
, libjpeg, libpng, ncurses, python, glib, libaio, mesa
, spice, spice_protocol, spiceSupport ? false }:

assert stdenv.isLinux;

let version = "1.0.1"; in

stdenv.mkDerivation rec {
  name = "qemu-kvm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/kvm/qemu-kvm/${version}/${name}.tar.gz";
    sha256 = "0kxzwaw8h71mqcm46angpyx8gd58ascrxnr861k068xg89ix5g2p";
  };

  patches = [ ./smb-tmpdir.patch ./qemu-img-fix-corrupt-vdi.patch ];

  postPatch =
    '' for i in $(find kvm -type f)
       do
         sed -i "$i" \
             -e 's|/bin/bash|/bin/sh|g ;
                 s|/usr/bin/python|${python}/bin/python|g ;
                 s|/bin/rm|rm|g'
       done
    '' + stdenv.lib.optionalString spiceSupport ''
       for i in configure spice-qemu-char.c ui/spice-input.c ui/spice-core.c ui/qemu-spice.h
       do
         substituteInPlace $i --replace '#include <spice.h>' '#include <spice/spice.h>'
       done
    '';

  configureFlags =
    [ "--audio-drv-list=alsa"
      "--smbd=smbd"                               # use `smbd' from $PATH
    ] ++ stdenv.lib.optional spiceSupport "--enable-spice";

  enableParallelBuilding = true;

  buildInputs =
    [ attr zlib SDL alsaLib pkgconfig pciutils libuuid vde2 libjpeg libpng
      ncurses python glib libaio mesa
    ] ++ stdenv.lib.optionals spiceSupport [ spice_protocol spice ];

  postInstall =
    ''
      # Libvirt expects us to be called `qemu-kvm'.  Otherwise it will
      # set the domain type to "qemu" rather than "kvm", which can
      # cause architecture selection to misbehave.
      ln -sv $(cd $out/bin && echo qemu-system-*) $out/bin/qemu-kvm
    '';

  meta = {
    homepage = http://www.linux-kvm.org/;
    description = "A full virtualization solution for Linux on x86 hardware containing virtualization extensions";
    platforms = stdenv.lib.platforms.linux;
  };
}
