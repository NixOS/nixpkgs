{ stdenv, fetchurl, autoconf, g77, texinfo, bison, flex, gperf
, rna, aterm
}:

assert autoconf != null && texinfo != null
  && bison != null && flex != null && gperf != null
  && rna != null && aterm != null;
assert g77.langF77;

stdenv.mkDerivation {
  name = "octavefront-0.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.radionetworkprocessor.com/pub/radionetworkprocessor/octavefront-0.2.tar.gz;
    md5 = "14e02d060fd6afc6752dbba0a7445ff2";
  };
  inherit autoconf g77 texinfo bison flex gperf rna aterm;
}
