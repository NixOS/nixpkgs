{ stdenv, fetchurl, gnutls, pkgconfig, readline, zlib, xz }:

stdenv.mkDerivation rec {
  name = "lftp-4.4.15";

  src = fetchurl {
    url = "http://lftp.yar.ru/ftp/${name}.tar.gz";
    sha256 = "1iw0xvvi9wr7grm6dwbxgm8ms98pg5skj44q477gxzrrff9dvvvp";
  };

  patches = [ ./no-gets.patch ];

  buildInputs = [ gnutls pkgconfig readline zlib ];

  meta = {
    homepage = http://lftp.yar.ru/;
    description = "A file transfer program supporting a number of network protocols";
    license = "GPL";
  };
}
