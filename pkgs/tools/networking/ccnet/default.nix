{stdenv, fetchurl, which, autoreconfHook, pkgconfig, vala, python, libsearpc, libzdb, libuuid, libevent, sqlite, openssl}:

stdenv.mkDerivation rec {
  version = "6.1.8";
  seafileVersion = "6.1.8";
  pname = "ccnet";

  src = fetchurl {
    url = "https://github.com/haiwen/ccnet/archive/v${version}.tar.gz";
    sha256 = "0qlpnrz30ldrqnvbj59d54qdghxpxc5lsq6kf3dw2b93jnzkcmmm";
  };

  nativeBuildInputs = [ pkgconfig which autoreconfHook vala python ];
  propagatedBuildInputs = [ libsearpc libzdb libuuid libevent sqlite openssl ];

  configureFlags = [ "--enable-server" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/ccnet;
    description = "A framework for writing networked applications in C";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
