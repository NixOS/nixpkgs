{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "module-init-tools-3.2-pre9";
  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/linux/utils/kernel/module-init-tools/module-init-tools-3.2-pre9.tar.bz2;
    md5 = "f0ede5936c52e3d59411bd9594ad364f";
  };
}
