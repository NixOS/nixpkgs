{stdenv, fetchurl, perl, m4}:

assert perl != null && m4 != null;

stdenv.mkDerivation {
  name = "uml-2.4.24-2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.4/linux-2.4.24.tar.bz2;
    md5 = "1e055c42921b2396a559d84df4c3d9aa";
#    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.4/linux-2.4.26.tar.bz2;
#    md5 = "88d7aefa03c92739cb70298a0b486e2c";
  };
  umlPatch = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/user-mode-linux/uml-patch-2.4.24-2.bz2;
    md5 = "f2aeb4d44f5734d63e98e6d66cc256de";
  };
  noAioPatch = ./no-aio.patch;
#  hostfsPatch = ./hostfs.patch;
#  hostfsAccessPatch = ./hostfs-access.patch;
  config = ./config;
  buildInputs = [perl m4];
}
