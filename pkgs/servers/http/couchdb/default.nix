{stdenv, fetchurl, erlang, spidermonkey, icu}:

stdenv.mkDerivation rec {
  name = "apache-couchdb-0.8.1-incubating";
  src = fetchurl {
    url = mirror://apache/incubator/couchdb/0.8.1-incubating/apache-couchdb-0.8.1-incubating.tar.gz;
    sha256 = "0w59kl7p5mgym1cd7j2pji6fcjq0y7yabcx2hx43vrcyjw31azv4";
  };

  buildInputs = [erlang spidermonkey icu];

  configureFlags = "--with-erlang=${erlang}/lib/erlang/usr/include"; 

}
