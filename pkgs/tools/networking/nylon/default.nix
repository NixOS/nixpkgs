{stdenv, fetchurl, libevent} :

stdenv.mkDerivation {
  name = "nylon-1.21";
  src = fetchurl {
    url = http://monkey.org/~marius/nylon/nylon-1.21.tar.gz;
    sha256 = "34c132b005c025c1a5079aae9210855c80f50dc51dde719298e1113ad73408a4";
  };

  configureFlags = [ "--with-libevent=${libevent}" ];

  buildInputs = [ libevent ];

  meta = {
    homepage = http://monkey.org/~marius/nylon;
    description = "Proxy server, supporting SOCKS 4 and 5, as well as a mirror mode";
    license = "free";
  };
}
