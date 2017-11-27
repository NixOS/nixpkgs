{ fetchurl, stdenv, pkgconfig, libtirpc, fetchpatch
, useSystemd ? true, systemd }:

stdenv.mkDerivation rec {
  name = "rpcbind-${version}";
  version = "0.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/rpcbind/${version}/${name}.tar.bz2";
    sha256 = "0rjc867mdacag4yqvs827wqhkh27135rp9asj06ixhf71m9rljh7";
  };

  patches = [
    ./sunrpc.patch
    (fetchpatch {
      name = "CVE-2017-8779.patch";
      url = "https://raw.githubusercontent.com/guidovranken/rpcbomb/e6da9e489aa8ad000b0ad5ac9abc5b4eefc3a769/rpcbind_patch.txt";
      sha256 = "0w231w8fxihgrn526np078j3vbj3ylvjvxjmfpjvqhga5zg821ab";
    })
  ];

  buildInputs = [ libtirpc ]
             ++ stdenv.lib.optional useSystemd systemd;

  configureFlags = [
    "--with-systemdsystemunitdir=${if useSystemd then "$(out)/etc/systemd/system" else "no"}"
    "--enable-warmstarts"
    "--with-rpcuser=rpc"
  ];

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
