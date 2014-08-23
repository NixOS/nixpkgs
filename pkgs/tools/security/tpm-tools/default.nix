{ stdenv, fetchurl, trousers, openssl }:

let
  version = "1.3.8";
in
stdenv.mkDerivation rec {
  name = "tpm-tools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/trousers/tpm-tools/${version}/${name}.tar.gz";
    sha256 = "10za1gi89vi9m2lmm7jfzs281h55x1sbbm2bdgdh692ljpq4zsv6";
  };

  buildInputs = [ trousers openssl ];

  meta = with stdenv.lib; {
    description = ''tpm-tools is an open-source package designed to enable user and application
                    enablement of Trusted Computing using a Trusted Platform Module (TPM),
                    similar to a smart card environment.'';
    homepage    = http://sourceforge.net/projects/trousers/files/tpm-tools/;
    license     = licenses.cpl10;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.unix;
  };
}

