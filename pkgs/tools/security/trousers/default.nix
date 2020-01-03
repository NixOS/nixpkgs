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

  NIX_CFLAGS_COMPILE = [ "-DALLOW_NON_TSS_CONFIG_FILE" ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Trusted computing software stack";
    homepage    = http://trousers.sourceforge.net/;
    license     = licenses.bsd3;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.linux;
  };
}
