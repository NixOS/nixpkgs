{ stdenv, libressl, fetchzip, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "pounce";
  version = "1.1";

  src = fetchzip {
    url = "https://git.causal.agency/pounce/snapshot/pounce-${version}.tar.gz";
    sha256 = "07iyh6ikrlf7y57k462jcr00db6aijk9b2s7n7l7i49hk7kmm6wq";
  };

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
