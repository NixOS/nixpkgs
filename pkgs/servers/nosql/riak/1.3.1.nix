{ stdenv, fetchurl, fetchFromGitHub, unzip, erlangR15}:

let
  srcs = {
    riak = fetchurl {
      url = "http://s3.amazonaws.com/downloads.basho.com/riak/1.3/1.3.1/riak-1.3.1.tar.gz";
      sha256 = "a69093fc5df1b79f58645048b9571c755e00c3ca14dfd27f9f1cae2c6e628f01";
    };
    leveldb = fetchFromGitHub {
      owner  = "basho";
      repo   = "leveldb";
      rev    = "1.3.1";
      sha256 = "1jvv260ic38657y4lwwcvzmhah8xai594xy19r28gkzlpra1lnbb";
    };
  };
in
stdenv.mkDerivation rec {
  name = "riak-1.3.1";

  buildInputs = [unzip erlangR15];

  src = srcs.riak;

  patches = [ ./riak-1.3.1.patch ./riak-admin-1.3.1.patch ];

  hardening_format = false;

  postUnpack = ''
    mkdir -p $sourceRoot/deps/eleveldb/c_src/leveldb
    cp -r ${srcs.leveldb}/* $sourceRoot/deps/eleveldb/c_src/leveldb
    chmod 755 -R $sourceRoot/deps/eleveldb/c_src/leveldb
    pushd $sourceRoot/deps/
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
    maintainers = [ stdenv.lib.maintainers.orbitz ];
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
