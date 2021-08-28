{ lib
, stdenv
, fetchurl
, pkg-config
, openssl ? null
, gnutls ? null
, gmp
, libxml2
, stoken
, zlib
, fetchgit
, darwin
, head ? false
  , fetchFromGitLab
  , autoreconfHook
}:

assert (openssl != null) == (gnutls == null);

let vpnc = fetchgit {
  url = "git://git.infradead.org/users/dwmw2/vpnc-scripts.git";
  rev = "c0122e891f7e033f35f047dad963702199d5cb9e";
  sha256 = "11b1ls012mb704jphqxjmqrfbbhkdjb64j2q4k8wb5jmja8jnd14";
};

in stdenv.mkDerivation rec {
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
    "--with-vpnc-script=${vpnc}/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  buildInputs = [ openssl gnutls gmp libxml2 stoken zlib ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.PCSC;
  nativeBuildInputs = [ pkg-config ]
    ++ lib.optional head autoreconfHook;

  meta = with lib; {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = "http://www.infradead.org/openconnect/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ pradeepchhetri tricktron ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
