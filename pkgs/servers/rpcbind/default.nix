{ fetchurl, fetchpatch, stdenv, pkgconfig, libtirpc
, useSystemd ? true, systemd }:

let version = "1.0.7";
in stdenv.mkDerivation rec {
  name = "rpcbind-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/rpcbind/${version}/${name}.tar.bz2";
    sha256 = "14vl0kmavc1fay630f4w8l1hjfzhmcqm8d0akzahhgymh5fw1f7r";
  };

  patches = [
    ./sunrpc.patch
    ./0001-handle_reply-Don-t-use-the-xp_auth-pointer-directly.patch
    (fetchpatch {
      url = "https://sources.debian.net/data/main/r/rpcbind/0.2.3-0.5/debian/patches/CVE-2015-7236.patch";
      sha256 = "1wsv5j8f5djzxr11n4027x107cam1avmx9w34g6l5d9s61j763wq";
    })
  ];

  buildInputs = [ libtirpc ]
             ++ stdenv.lib.optional useSystemd systemd;

  configureFlags = stdenv.lib.optional (!useSystemd) "--with-systemdsystemunitdir=no";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "ONC RPC portmapper";
    license = licenses.bsd3;
    platforms = platforms.unix;
    homepage = "http://sourceforge.net/projects/rpcbind/";
    maintainers = with maintainers; [ abbradar ];
    longDescription = ''
      Universal addresses to RPC program number mapper.
    '';
  };
}
