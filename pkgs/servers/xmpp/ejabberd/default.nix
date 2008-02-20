{stdenv, fetchurl, expat, erlang, zlib, openssl}:

stdenv.mkDerivation {
  name = "ejabberd-2.0.0-rc1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.process-one.net/downloads/ejabberd/2.0.0-rc1/ejabberd-2.0.0-rc1.tar.gz;
    sha256 = "02ldssvsy0rkvxm96018fpk5lc3iqgkrira9cw1ym2snas0k8nzy";
  };
  inherit expat erlang zlib openssl;
}
