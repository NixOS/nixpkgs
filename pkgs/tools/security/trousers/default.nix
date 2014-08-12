{ stdenv, fetchurl, openssl }:

let
  ver_maj = "0.3.11";
  ver_min = "2";
in
stdenv.mkDerivation rec {
  name = "trousers-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://sourceforge/trousers/trousers/${ver_maj}/${name}.tar.gz";
    sha256 = "1m9qi4452jr5yy4y9zyfi5ndwam5krq7ny8z2q3f91v1hcjgk5la";
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

