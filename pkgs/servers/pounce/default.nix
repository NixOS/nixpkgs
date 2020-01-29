{ stdenv, libressl, fetchzip, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "pounce";
  version = "1.0p1";

  src = fetchzip {
    url = "https://code.causal.agency/june/pounce/archive/${version}.zip";
    sha256 = "1fh1cf15ybl962n7x70hlg7zfcmpwgq6q90s74d3jhawmjj01syw";
  };

  patches = [
    # Don't always create ${ETCDIR}/rc.d
    (fetchpatch {
      url = https://code.causal.agency/june/pounce/commit/db65889605a2fa5352e90a573b7584a6b7a59dd5.patch;
      sha256 = "0bxhig72g4q0hs8lb7g8lb7kf0w9jdy22qwm9yndlwrdw3vi36zq";
    })
    # Simplify Linux.mk
    (fetchpatch {
      url = https://code.causal.agency/june/pounce/commit/b7dc2e3439a37d23d4847e130b37ece39b8efdd7.patch;
      sha256 = "0c2pa6w9abkmaaq4957arfmpsrn933vcrs4a2da785v57pgkj4lq";
    })
    # Reference openssl(1) by absolute path
    (fetchpatch {
      url = https://code.causal.agency/june/pounce/commit/973f19b4fe73ef956fbb4eeaf963bbb83c926203.patch;
      sha256 = "1w4rhwqfcakzb9a6afq788rrsypay0rw75bjk2f3l66spjb7v3ps";
    })
  ];

  buildInputs = [ libressl ];

  configurePhase = "ln -s Linux.mk config.mk";

  buildFlags = [ "all" ];

  makeFlags = [
    "PREFIX=$(out)"
    "LIBRESSL_BIN_PREFIX=${libressl}/bin"
  ];

  meta = with stdenv.lib; {
    homepage = https://code.causal.agency/june/pounce;
    description = "Simple multi-client TLS-only IRC bouncer";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edef ];
  };
}
