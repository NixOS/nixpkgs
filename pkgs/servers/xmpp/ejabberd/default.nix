{stdenv, fetchurl, expat, erlang, zlib, openssl}:

stdenv.mkDerivation {
  name = "ejabberd-1.1.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.process-one.net/downloads/ejabberd/1.1.4/ejabberd-1.1.4.tar.gz;
    md5 = "65e9cd346f11a28afbacfe1d7be3a33b";
  };
  inherit expat erlang zlib openssl;
}
