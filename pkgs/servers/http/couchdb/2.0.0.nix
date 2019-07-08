{ stdenv, fetchurl, erlang, icu, openssl, spidermonkey
, coreutils, bash, makeWrapper }:

stdenv.mkDerivation rec {
  name = "couchdb-${version}";
  version = "2.3.0";

  src = fetchurl {
    url = "mirror://apache/couchdb/source/${version}/apache-${name}.tar.gz";
    sha256 = "0lpk64n6fip85j1jz59kq20jdliwv6mh8j2h5zyxjn5i8b86hf0b";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ erlang icu openssl spidermonkey ];

  patches = [ ./jsapi.patch ];
  postPatch = ''
    substituteInPlace src/couch/rebar.config.script --replace '-DHAVE_CURL -I/usr/local/include' "-DHAVE_CURL -I/usr/local/include $NIX_CFLAGS_COMPILE"

    patch bin/rebar <<EOF
    1c1
    < #!/usr/bin/env escript
    ---
    > #!${coreutils}/bin/env escript
    EOF

  '';

  # Configure a username.  The build system would use "couchdb" as
  # default if none is provided.  Note that it is unclear where this
  # username is actually used in the build, as any choice seems to be
  # working.
  configurePhase = ''
    ./configure -u nobody
  '';

  buildPhase = ''
    make release
  '';

  installPhase = ''
    mkdir -p $out
    cp -r rel/couchdb/* $out
    wrapProgram $out/bin/couchdb --suffix PATH : ${bash}/bin
  '';

  meta = with stdenv.lib; {
    description = "A database that uses JSON for documents, JavaScript for MapReduce queries, and regular HTTP for an API";
    homepage = http://couchdb.apache.org;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
