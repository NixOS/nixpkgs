{ lib
, stdenv
, fetchurl
, pkg-config
, openssl ? null
, gnutls ? null
, p11-kit
, gmp
, libxml2
, stoken
, zlib
, vpnc-scripts
, PCSC
, head ? false
  , fetchFromGitLab
  , autoreconfHook
}:

assert (openssl != null) == (gnutls == null);

stdenv.mkDerivation rec {
  pname = "openconnect${lib.optionalString head "-head"}";
  version = if head then "2021-05-05" else "8.10";

  src =
    if head then fetchFromGitLab {
      owner = "openconnect";
      repo = "openconnect";
      rev = "684f6db1aef78e61e01f511c728bf658c30b9114";
      sha256 = "0waclawcymgd8sq9xbkn2q8mnqp4pd0gpyv5wrnb7i0nsv860wz8";
    }
    else fetchurl {
      url = "ftp://ftp.infradead.org/pub/openconnect/${pname}-${version}.tar.gz";
      sha256 = "1cdsx4nsrwawbsisfkldfc9i4qn60g03vxb13nzppr2br9p4rrih";
    };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--with-vpnc-script=${vpnc-scripts}/bin/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  buildInputs = [ openssl gnutls gmp libxml2 stoken zlib ]
    ++ lib.optional stdenv.isDarwin PCSC
    ++ lib.optional stdenv.isLinux p11-kit;
  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional head autoreconfHook;

  meta = with lib; {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = "https://www.infradead.org/openconnect/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ pradeepchhetri tricktron ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
