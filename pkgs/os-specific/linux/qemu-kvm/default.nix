{ stdenv, fetchurl, attr, zlib, SDL, alsaLib, pkgconfig, pciutils, libuuid, vde2
, libjpeg, libpng, ncurses, python, glib, libaio, mesa }:

assert stdenv.isLinux;

let version = "1.1.1"; in

stdenv.mkDerivation rec {
  name = "qemu-kvm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/kvm/${name}.tar.gz";
    sha256 = "1pwnqxcz0xxm7ljhr7gjr3rs0h811a2271kj6kmmvbfwr9ybbyn6";
  };

  patches = [ ./smb-tmpdir.patch ];

  postPatch =
    '' for i in $(find kvm -type f)
       do
         sed -i "$i" \
             -e 's|/bin/bash|/bin/sh|g ;
                 s|/usr/bin/python|${python}/bin/python|g ;
                 s|/bin/rm|rm|g'
       done
    '';

  configureFlags =
    [ "--audio-drv-list=alsa"
      "--smbd=smbd"                               # use `smbd' from $PATH
    ];

  enableParallelBuilding = true;

  buildInputs =
    [ attr zlib SDL alsaLib pkgconfig pciutils libuuid vde2 libjpeg libpng
      ncurses python glib libaio mesa
    ];

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
