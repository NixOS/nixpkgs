{stdenv, fetchurl, patch, perl, m4}:

assert patch != null && perl != null && m4 != null;

stdenv.mkDerivation {
  name = "uml-2.4.25-1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.kernel.org/pub/linux/kernel/v2.4/linux-2.4.25.tar.bz2;
    md5 = "5fc8e9f43fa44ac29ddf9a9980af57d8";
  };
  umlPatch = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/user-mode-linux/uml-patch-2.4.25-1.bz2;
    md5 = "aacbb7b19ec7599119313a31328e1912";
  };
  noAioPatch = ./no-aio.patch;
  config = ./config;
  buildInputs = [patch perl m4];
}
