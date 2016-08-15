{ stdenv, fetchurl, libevent, buildEnv }:
let
  # failed to find a better way to make it work
  libevent-comb = buildEnv {
    inherit (libevent.out) name;
    paths = [ libevent.dev libevent.out ];
  };
in
stdenv.mkDerivation {
  name = "nylon-1.21";
  src = fetchurl {
    url = http://monkey.org/~marius/nylon/nylon-1.21.tar.gz;
    sha256 = "34c132b005c025c1a5079aae9210855c80f50dc51dde719298e1113ad73408a4";
  };

  patches = [ ./configure-use-solib.patch ];

  configureFlags = [ "--with-libevent=${libevent-comb}" ];

  buildInputs = [ libevent ];

  meta = with stdenv.lib; {
    homepage = http://monkey.org/~marius/nylon;
    description = "Proxy server, supporting SOCKS 4 and 5, as well as a mirror mode";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ edwtjo viric ];
    platforms = platforms.linux;
  };
}
