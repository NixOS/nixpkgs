{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "module-init-tools-3.2.1";
  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/linux/utils/kernel/module-init-tools/module-init-tools-3.2.1.tar.bz2;
    md5 = "29aa770c6ce92cbbc6da00161d2784d8";
  };
}


