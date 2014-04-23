{stdenv, fetchurl, autoconf, automake, openssl}:

stdenv.mkDerivation {
  name = "trousers-0.3.11.2";

  src = fetchurl {
    url = https://sourceforge.net/projects/trousers/files/trousers/0.3.11/trousers-0.3.11.2.tar.gz;
    sha256 = "03c71szmij1nx3jicacmazh0yan3qm00k0ahmh4mq88fw00k1p4v";
  };

  buildInputs = [ openssl ];

  patches = [ # ./double-installed-man-page.patch
              ./disable-install-rule.patch
              ./allow-non-tss-config-file-owner.patch
            ];

  NIX_CFLAGS_COMPILE = "-DALLOW_NON_TSS_CONFIG_FILE";
  NIX_LDFLAGS = "-lgcc_s";

  meta = with stdenv.lib; {
    description = "TrouSerS is an CPL (Common Public License) licensed Trusted Computing Software Stack.";
    homepage    = http://trousers.sourceforge.net/;
    license     = licenses.cpl10;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.unix;
  };
}
