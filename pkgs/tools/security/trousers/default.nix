{ stdenv, fetchurl, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "trousers";
  version = "0.3.14";

  src = fetchurl {
    url = "mirror://sourceforge/trousers/trousers/${version}/${pname}-${version}.tar.gz";
    sha256 = "0iwgsbrbb7nfqgl61x8aailwxm8akxh9gkcwxhsvf50x4qx72l6f";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  patches = [ ./allow-non-tss-config-file-owner.patch ];

  configureFlags = [ "--disable-usercheck" ];

  # Attempt to remove -std=gnu89 when updating if using gcc5
  NIX_CFLAGS_COMPILE = "-std=gnu89 -DALLOW_NON_TSS_CONFIG_FILE";
  NIX_LDFLAGS = "-lgcc_s";

  # Fix broken libtool file
  preFixup = stdenv.lib.optionalString (!stdenv.isDarwin) ''
    sed 's,-lcrypto,-L${openssl.out}/lib -lcrypto,' -i $out/lib/libtspi.la
  '';

  meta = with stdenv.lib; {
    description = "Trusted computing software stack";
    homepage    = http://trousers.sourceforge.net/;
    license     = licenses.cpl10;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.linux;
  };
}

