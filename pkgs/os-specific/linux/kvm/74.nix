{stdenv, fetchurl, kernelHeaders, zlib, e2fsprogs, SDL, alsaLib, pkgconfig, rsync}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation {
  name = "kvm-74";
   
  src = fetchurl {
    url = mirror://sourceforge/kvm/kvm-74.tar.gz;
    sha256 = "0gnd5r9wb8mar3jh8gv46vdm3qkbgiwzkim5ki67kx3ca71g0m24";
  };

  patches = [
    # Allow setting the path to Samba through $QEMU_SMBD_COMMAND.
    ./smbd-path.patch
    # The makefile copies stuff from the kernel directory and then
    # tries to modify the copy, but it must be made writable first.
    ./readonly-kernel-r2.patch
  ];

  configureFlags = "--with-patched-kernel --kerneldir=${kernelHeaders}";

  # e2fsprogs is needed for libuuid.
  # rsync is a weird dependency used for copying kernel header files.
  buildInputs = [zlib e2fsprogs SDL alsaLib pkgconfig rsync];

  preConfigure = ''
    for i in configure user/configure; do
      substituteInPlace $i --replace /bin/bash $shell
    done
    substituteInPlace libkvm/Makefile --replace kvm_para.h kvm.h # !!! quick hack
  '';

  meta = {
    homepage = http://kvm.qumranet.com/;
    description = "A full virtualization solution for Linux on x86 hardware containing virtualization extensions";
  };
}
