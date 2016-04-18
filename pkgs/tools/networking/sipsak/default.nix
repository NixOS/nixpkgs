{ stdenv, fetchurl, autoreconfHook, c-ares, openssl ? null }:

stdenv.mkDerivation rec {
  name = "sipsak-${version}";
  version = "4.1.2.1";

  buildInputs = [
    autoreconfHook
    openssl
    c-ares
  ];

  NIX_CFLAGS_COMPILE = "--std=gnu89";

  src = fetchurl {
    url = "https://github.com/sipwise/sipsak/archive/mr${version}.tar.gz";
    sha256 = "769fe59966b1962b67aa35aad7beb9a2110ebdface36558072a05c6405fb5374";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/sipwise/sipsak;
    description = "SIP Swiss army knife";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ sheenobu ];
  };

}

