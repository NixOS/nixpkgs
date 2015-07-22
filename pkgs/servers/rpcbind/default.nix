{ fetchurl, stdenv, pkgconfig, libtirpc
, useSystemd ? true, systemd }:

let version = "1.0.7";
in stdenv.mkDerivation rec {
  name = "rpcbind-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/rpcbind/${version}/${name}.tar.bz2";
    sha256 = "14vl0kmavc1fay630f4w8l1hjfzhmcqm8d0akzahhgymh5fw1f7r";
  };

  patches = [ ./sunrpc.patch ];
  postPatch = ''
    sed -e 's|/usr/include/tirpc|${libtirpc}/include/tirpc|' -i src/Makefile.am -i src/Makefile.in
  '';

  buildInputs = [ libtirpc ]
             ++ stdenv.lib.optional useSystemd systemd;

  configureFlags = stdenv.lib.optional (!useSystemd) "--with-systemdsystemunitdir=no";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "ONC RPC portmapper";
    license = licenses.bsd3;
    platforms = platforms.unix;
    homepage = http://sourceforge.net/projects/rpcbind/;
    maintainers = with maintainers; [ abbradar ];
    longDescription = ''
      Universal addresses to RPC program number mapper.
    '';
  };
}
