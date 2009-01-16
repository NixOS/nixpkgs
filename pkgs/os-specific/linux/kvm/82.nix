{stdenv, fetchurl, kernelHeaders, zlib, e2fsprogs, SDL, alsaLib, pkgconfig, rsync}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation {
  name = "kvm-82";
   
  src = fetchurl {
    url = mirror://sourceforge/kvm/kvm-82.tar.gz;
    sha256 = "1fk58g8z9v7z42vy76zq0sq28slqf8zszzmh73vyxm07vfbc96zs";
  };

  patches = [
    # Allow setting the path to Samba through $QEMU_SMBD_COMMAND.
    ./smbd-path-r2.patch
    # The makefile copies stuff from the kernel directory and then
    # tries to modify the copy, but it must be made writable first.
    ./readonly-kernel-r3.patch
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
