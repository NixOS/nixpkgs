{ fetchurl, stdenv, pkgconfig, libtirpc
, useSystemd ? true, systemd }:

let version = "0.2.2";
in stdenv.mkDerivation rec {
  name = "rpcbind-${version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/rpcbind/${version}/${name}.tar.bz2";
    sha256 = "0acgl1c07ymnks692b90aq5ldj4h0km7n03kz26wxq6vjv3winqk";
  };

  patches = [ ./sunrpc.patch ];

  buildInputs = [ libtirpc ]
             ++ stdenv.lib.optional useSystemd systemd;

  configureFlags = stdenv.lib.optional (!useSystemd) "--with-systemdsystemunitdir=no";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "ONC RPC portmapper";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
    longDescription = ''
      Universal addresses to RPC program number mapper.
    '';
  };
}
