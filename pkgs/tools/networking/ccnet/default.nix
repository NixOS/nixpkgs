{stdenv, fetchurl, which, autoreconfHook, pkgconfig, vala, python, libsearpc, libzdb, libuuid, libevent, sqlite, openssl}:

stdenv.mkDerivation rec {
  version = "6.1.7";
  seafileVersion = "6.1.7";
  name = "ccnet-${version}";

  src = fetchurl {
    url = "https://github.com/haiwen/ccnet/archive/v${version}.tar.gz";
    sha256 = "1kkzdxa9r7sw1niwniznfkvilgvb7q039wq07cfk73qs3231bj7r";
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
