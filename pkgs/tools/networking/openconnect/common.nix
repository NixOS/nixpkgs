{ version
, src
}:

{ lib
, stdenv
, fetchpatch
, pkg-config
, gnutls
, p11-kit
, openssl
, useOpenSSL ? false
, gmp
, libxml2
, stoken
, zlib
, vpnc-scripts
, PCSC
, useDefaultExternalBrowser ? stdenv.isLinux && stdenv.buildPlatform == stdenv.hostPlatform # xdg-utils doesn't cross-compile
, xdg-utils
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "openconnect";
  inherit version src;

  patches = [
    # Fix build with libxml 2.12.
    # https://gitlab.com/openconnect/openconnect/-/merge_requests/505
    (fetchpatch {
      url = "https://gitlab.com/openconnect/openconnect/-/commit/06af9454c29b3aff53aede30cfb15071be4ddc14.patch";
      hash = "sha256-lPTgfj6b9Jv1P/Cs88PbDd0m0kSqG5Uce+5ea9vyDzQ=";
    })
  ];

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--with-vpnc-script=${vpnc-scripts}/bin/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  buildInputs = [ gmp libxml2 stoken zlib (if useOpenSSL then openssl else gnutls) ]
    ++ lib.optional stdenv.isDarwin PCSC
    ++ lib.optional stdenv.isLinux p11-kit
    ++ lib.optional useDefaultExternalBrowser xdg-utils;
  nativeBuildInputs = [ pkg-config autoreconfHook ];

  meta = with lib; {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = "https://www.infradead.org/openconnect/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ pradeepchhetri tricktron alyaeanyx ];
    platforms = lib.platforms.unix;
  };
}
