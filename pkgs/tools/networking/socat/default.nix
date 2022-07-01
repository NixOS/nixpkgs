{ lib
, fetchurl
, nettools
, openssl
, readline
, stdenv
, which
}:

stdenv.mkDerivation rec {
  pname = "socat";
  version = "1.7.4.3";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${pname}-${version}.tar.bz2";
    sha256 = "sha256-1HMYEEQVB3Y1EZ3+5EvPtB3jSXN0qaABsa/24vCFgAc=";
  };

  postPatch = ''
    patchShebangs test.sh
    substituteInPlace test.sh \
      --replace /bin/rm rm \
      --replace /sbin/ifconfig ifconfig
  '';

  configureFlags = lib.optionals stdenv.hostPlatform.isMusl [
    # musl doesn't have getprotobynumber_r
    "sc_cv_getprotobynumber_r=2"
  ];

  buildInputs = [ openssl readline ];

  hardeningEnable = [ "pie" ];

  checkInputs = [ which nettools ];
  doCheck = false; # fails a bunch, hangs

  meta = with lib; {
    description = "Utility for bidirectional data transfer between two independent data channels";
    homepage = "http://www.dest-unreach.org/socat/";
    platforms = platforms.unix;
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ eelco ];
  };
}
