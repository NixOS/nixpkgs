{stdenv, fetchurl, autoconf, automake, trousers, openssl}:

stdenv.mkDerivation {
  name = "tpm-tools-1.3.8";

  src = fetchurl {
    url = https://sourceforge.net/projects/trousers/files/tpm-tools/1.3.8/tpm-tools-1.3.8.tar.gz;
    sha256 = "10za1gi89vi9m2lmm7jfzs281h55x1sbbm2bdgdh692ljpq4zsv6";
  };

  buildInputs = [ trousers openssl ];
}
