{ stdenv, kurentoPackages }:

stdenv.mkDerivation rec {
  pname = "libsrtp-kurento";
  version = "1.6.0-0kurento1";

  patches = [
    # Allow receiving packets that are replayed
    "${src}/debian/patches/0009-Always-allow-receiving-repeated-packets-rx-replay.patch"
    # Allow sending packets that are replayed (this way we don't have to patch gst as well)
    ./srtp-tx-replay.patch
  ];

  src = kurentoPackages.lib.fetchKurento {
    repo = "libsrtp";
    sha256 = "sha256-QYb5WDFuOmXsXuK4qsbPWDhLcP2UNI5vH8l+L8MqXEE=";
    rev = "577e0a51c8e237b0590f31f6371eb41e1c435962";
  };

  meta = with stdenv.lib; {
    description = "Library for SRTP (Secure Realtime Transport Protocol) - Kurento fork";
    homepage = "https://github.com/kurento/libsrtp";
    license = with licenses; [ bsd3 ];
  };
}
