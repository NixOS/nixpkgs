{stdenv, fetchurl, kernelHeaders, zlib, e2fsprogs, SDL, alsaLib}:
   
stdenv.mkDerivation {
  name = "kvm-12";
   
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/kvm/kvm-12.tar.gz;
    sha256 = "0w2w4kzir1qsapfav30bhng061570zl12ycyvpgwlx2br4s9mlmw";
  };

  configureFlags = "--with-patched-kernel --kerneldir=${kernelHeaders}";

  # e2fsprogs is needed for libuuid.
  buildInputs = [zlib e2fsprogs SDL alsaLib];
}
