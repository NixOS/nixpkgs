{stdenv, fetchurl, kernelHeaders, zlib, e2fsprogs, SDL, alsaLib}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation {
  name = "kvm-49";
   
  src = fetchurl {
    url = mirror://sourceforge/kvm/kvm-49.tar.gz;
    sha256 = "0ml7dlxg6alhrhdlp83j53bpwlbn3nfl8dga5jrmhaqmzpx4d8kp";
  };

  configureFlags = "--with-patched-kernel --kerneldir=${kernelHeaders}";

  # e2fsprogs is needed for libuuid.
  buildInputs = [zlib e2fsprogs SDL alsaLib];

  preConfigure = "for i in configure user/configure; do substituteInPlace $i --replace /bin/bash $shell; done";
}
