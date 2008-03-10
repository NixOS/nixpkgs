{stdenv, fetchurl, kernelHeaders, zlib, e2fsprogs, SDL, alsaLib}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation {
  name = "kvm-57";
   
  src = fetchurl {
    url = mirror://sourceforge/kvm/kvm-57.tar.gz;
    sha256 = "016h5pf59fyz7skzsaprii2mdpxpb8hfnnr1w475qcfyy6ccr9r0";
  };

  configureFlags = "--with-patched-kernel --kerneldir=${kernelHeaders}";

  # e2fsprogs is needed for libuuid.
  buildInputs = [zlib e2fsprogs SDL alsaLib];

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
