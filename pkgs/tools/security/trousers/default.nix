{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name = "trousers-${version}";
  version = "0.3.13";

  src = fetchurl {
    url = "mirror://sourceforge/trousers/trousers/${version}/${name}.tar.gz";
    sha256 = "1lvnla1c1ig2w3xvvrqg2w9qm7a1ygzy1j2gg8j7p8c87i58x45v";
  };

  buildInputs = [ openssl ];

  patches = [ ./allow-non-tss-config-file-owner.patch ];

  configureFlags = [ "--disable-usercheck" ];

  NIX_CFLAGS_COMPILE = "-DALLOW_NON_TSS_CONFIG_FILE";
  NIX_LDFLAGS = "-lgcc_s";

  meta = with stdenv.lib; {
    description = "Trusted computing software stack";
    homepage    = http://trousers.sourceforge.net/;
    license     = licenses.cpl10;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.unix;
  };
}

