{ version
, src
}:

{ lib
, stdenv
, pkg-config
, gnutls
, p11-kit
, openssl
, useOpenSSL ? false
, gmp
, libxml2
, stoken
, zlib
, pcsclite
, vpnc-scripts
, PCSC
, useDefaultExternalBrowser ? stdenv.isLinux && stdenv.buildPlatform == stdenv.hostPlatform # xdg-utils doesn't cross-compile
, xdg-utils
, autoreconfHook
}:

stdenv.mkDerivation {
  pname = "openconnect";
  inherit version src;

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--with-vpnc-script=${vpnc-scripts}/bin/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  buildInputs = [ gmp libxml2 stoken zlib (if useOpenSSL then openssl else gnutls) ]
    ++ lib.optional stdenv.isDarwin PCSC
    ++ lib.optionals stdenv.isLinux [ p11-kit pcsclite ]
    ++ lib.optional useDefaultExternalBrowser xdg-utils;
  nativeBuildInputs = [ pkg-config autoreconfHook ];

  meta = with lib; {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = "https://www.infradead.org/openconnect/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ pradeepchhetri tricktron alyaeanyx ];
    platforms = lib.platforms.unix;
    mainProgram = "openconnect";
  };
}
