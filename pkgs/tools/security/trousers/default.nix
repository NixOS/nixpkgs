{ lib, stdenv, fetchurl, openssl, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "trousers";
  version = "0.3.15";

  src = fetchurl {
    url = "mirror://sourceforge/trousers/trousers/${version}/${pname}-${version}.tar.gz";
    sha256 = "0zy7r9cnr2gvwr2fb1q4fc5xnvx405ymcbrdv7qsqwl3a4zfjnqy";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ openssl ];

  patches = [ ./allow-non-tss-config-file-owner.patch ];

  configureFlags = [ "--disable-usercheck" ];

  env.NIX_CFLAGS_COMPILE = toString [ "-DALLOW_NON_TSS_CONFIG_FILE" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Trusted computing software stack";
    homepage    = "https://trousers.sourceforge.net/";
    license     = licenses.bsd3;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.linux;
  };
}
