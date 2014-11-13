{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "zeromq";
  version = "4.1.0-rc1";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}-${version}.tar.gz";
    sha256 = "e8e6325abe2ede0a9fb3d1abbe425d8a7911f6ac283652ee49b36afbb0164d60";
  };

  doCheck = true;

  meta = {
    description = "0MQ is a lightweight messaging kernel";
    longDescription = ''
      The 0MQ lightweight messaging kernel is a library which extends
      the standard socket interfaces with features traditionally provided
      by specialised messaging middleware products. 0MQ sockets provide
      an abstraction of asynchronous message queues, multiple messaging patterns,
      message filtering (subscriptions), seamless access to multiple transport protocols
      and more.
    '';
    homepage = http://zeromq.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.gavin ];
    platforms = stdenv.lib.platforms.all;
  };
}
