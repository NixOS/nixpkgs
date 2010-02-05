{stdenv, fetchurl, linuxHeaders, zlib, SDL, alsaLib, pkgconfig, pciutils}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation rec {
  name = "kvm-86";
   
  src = fetchurl {
    url = "mirror://sourceforge/kvm/${name}.tar.gz";
    sha256 = "17fq2dyd0qla0yiddyiqvb8kz3sfy6dhy9fi9y7xcbhs26s0wxax";
  };

  patches = [
    # Allow setting the path to Samba through $QEMU_SMBD_COMMAND.
    ./smbd-path-r3.patch

    # Support the "vga" kernel command line option when using the
    # -kernel option.
    ./x86_boot_vidmode.patch
  ];

  configureFlags = "--enable-io-thread";

  # e2fsprogs is needed for libuuid.
  # rsync is a weird dependency used for copying kernel header files.
  buildInputs = [zlib SDL alsaLib pkgconfig pciutils];

  preConfigure = ''
    for i in configure kvm/configure kvm/user/configure; do
      substituteInPlace $i --replace /bin/bash $shell
    done
    
    substituteInPlace kvm/libkvm/Makefile --replace kvm_para.h kvm.h # !!! quick hack

    # This prevents the kernel module from being built.
    rm kvm/kernel/configure
  '';

  meta = {
    homepage = http://kvm.qumranet.com/;
    description = "A full virtualization solution for Linux on x86 hardware containing virtualization extensions";
  };
}
