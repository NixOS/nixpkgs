{ stdenv, fetchurl, attr, zlib, SDL, alsaLib, pkgconfig, pciutils, libuuid, vde2
, libjpeg, libpng, ncurses, python, glib, libaio, mesa, perl, texinfo
, spice, spice_protocol, spiceSupport ? false }:

assert stdenv.isLinux;

let version = "1.2.0"; in

stdenv.mkDerivation rec {
  name = "qemu-kvm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/kvm/qemu-kvm/${version}/${name}.tar.gz";
    sha256 = "018vb5nmk2fsm143bs2bl2wirhasd4b10d7jchl32zik4inbk2p9";
  };

  buildInputs =
    [ attr zlib SDL alsaLib pkgconfig pciutils libuuid vde2 libjpeg libpng
      ncurses python glib libaio mesa texinfo perl
    ] ++ stdenv.lib.optionals spiceSupport [ spice_protocol spice ];

  patchPhase = "patchShebangs ." + stdenv.lib.optionalString spiceSupport ''
       for i in configure spice-qemu-char.c ui/spice-input.c ui/spice-core.c ui/qemu-spice.h; do
         substituteInPlace $i --replace '#include <spice.h>' '#include <spice/spice.h>'
       done
    '';

  configureFlags =
    [ "--audio-drv-list=alsa"
      "--smbd=smbd"                               # use `smbd' from $PATH
      "--enable-docs"
      "--python=${python}/bin/python"
    ] ++ stdenv.lib.optional spiceSupport "--enable-spice";

  postInstall =
    ''
      # Libvirt expects us to be called `qemu-kvm'.  Otherwise it will
      # set the domain type to "qemu" rather than "kvm", which can
      # cause architecture selection to misbehave.
      ln -sv $(cd $out/bin && echo qemu-system-*) $out/bin/qemu-kvm
    '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.linux-kvm.org/;
    description = "A full virtualization solution for Linux on x86 hardware containing virtualization extensions";
    platforms = stdenv.lib.platforms.linux;
  };
}
