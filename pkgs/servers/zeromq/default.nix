{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "zeromq";
  version = "4.1.0-rc1";

  src = fetchurl {
    url = "http://download.zeromq.org/${name}-${version}.tar.gz";
    sha256 = "e8e6325abe2ede0a9fb3d1abbe425d8a7911f6ac283652ee49b36afbb0164d60";
  };

  # https://github.com/zeromq/libzmq/pull/1260
  patches = [ (fetchpatch {
                url = https://github.com/zeromq/libzmq/commit/32b2d3034b04a54118bc95c3f83ea5af78f9de41.diff;
                sha256 = "07vflr6xi5lrvbliknhr58fahv1f9qnz9dbfz12g83nx1mbvjv5d";
              })
            ];

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
