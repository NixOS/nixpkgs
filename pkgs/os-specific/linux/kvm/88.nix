{stdenv, fetchurl, kernelHeaders, zlib, SDL, alsaLib, pkgconfig, pciutils}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation rec {
  name = "kvm-88";
   
  src = fetchurl {
    url = "mirror://sourceforge/kvm/${name}.tar.gz";
    sha256 = "0gmmcwgkfk15wkcjaaa28nrzb0w3vbhg8p585qin61hz6kcy8ryw";
  };

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
