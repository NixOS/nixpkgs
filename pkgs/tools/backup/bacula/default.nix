{ stdenv, fetchurl, sqlite, postgresql, zlib, acl, ncurses, openssl, readline }:

stdenv.mkDerivation rec {
  name = "bacula-5.2.13";

  src = fetchurl {
    url    = "mirror://sourceforge/bacula/${name}.tar.gz";
    sha256 = "1n3sc0kd7r0afpyi708y3md0a24rbldnfcdz0syqj600pxcd9gm4";
  };

  buildInputs = [ postgresql sqlite zlib ncurses openssl readline ]
    # acl relies on attr, which I can't get to build on darwin
    ++ stdenv.lib.optional (!stdenv.isDarwin) acl;

  configureFlags = [ 
    "--with-sqlite3=${sqlite.dev}"
    "--with-postgresql=${postgresql}"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/sbin/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Enterprise ready, Network Backup Tool";
    homepage    = http://bacula.org/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ iElectric lovek323 ];
    platforms   = platforms.all;
  };
}
