{stdenv, fetchurl, kernelHeaders, zlib, e2fsprogs, SDL, alsaLib}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation {
  name = "kvm-17";
   
  src = fetchurl {
    url = mirror://sourceforge/kvm/kvm-17.tar.gz;
    sha256 = "1c9g92258wbadh6q8m9vp4zszbr50a5crn93iy69s5bkg3n3vs43";
  };

  configureFlags = "--with-patched-kernel --kerneldir=${kernelHeaders}";

  # e2fsprogs is needed for libuuid.
  buildInputs = [zlib e2fsprogs SDL alsaLib];

  preConfigure = "for i in configure user/configure; do substituteInPlace $i --replace /bin/bash $shell; done";
}
