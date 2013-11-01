{ stdenv, fetchurl, unzip, erlangR15B03 }:

let
  srcs = {
     riak = fetchurl {
      url = "http://s3.amazonaws.com/downloads.basho.com/riak/1.3/1.3.1/riak-1.3.1.tar.gz";
      sha256 = "a69093fc5df1b79f58645048b9571c755e00c3ca14dfd27f9f1cae2c6e628f01";
    };
     leveldb = fetchurl {
      url = "https://github.com/basho/leveldb/archive/1.3.1.zip";
      sha256 = "dc48ba2b44fca11888ea90695d385c494e1a3abd84a6b266b07fdc160ab2ef64";
    };
  };
in
stdenv.mkDerivation rec {
  name = "riak-1.3.1";

  buildInputs = [unzip erlangR15B03];

  src = srcs.riak;

  patches = [ ./riak-1.3.1.patch ./riak-admin-1.3.1.patch ];

  postUnpack = ''
    ln -sv ${srcs.leveldb} $sourceRoot/deps/eleveldb/c_src/leveldb.zip
    pushd $sourceRoot/deps/eleveldb/c_src/
    unzip leveldb.zip
    mv leveldb-* leveldb
    cd ../../
    mkdir riaknostic/deps
    cp -R lager riaknostic/deps
    cp -R getopt riaknostic/deps
    cp -R meck riaknostic/deps
    popd
    patchShebangs .
  '';

  buildPhase = ''
    make rel
  '';

  doCheck = false;

  installPhase = ''
    mkdir $out
    mv rel/riak/etc rel/riak/riak-etc
    mkdir -p rel/riak/etc
    mv rel/riak/riak-etc rel/riak/etc/riak
    mv rel/riak/* $out
  '';

  meta = {
    maintainers = stdenv.lib.maintainers.orbitz;
    description = "Dynamo inspired NoSQL DB by Basho";
    longDescription = ''
      This patches the riak and riak-admin scripts to work better in Nix.
      Rather than the scripts using their own location to determine where
      the data, log, and etc directories should live, the scripts expect
      RIAK_DATA_DIR, RIAK_LOG_DIR, and RIAK_ETC_DIR to be defined
      and use those.
    '';
    platforms   = stdenv.lib.platforms.all;
  };
}
