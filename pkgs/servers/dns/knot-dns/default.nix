{ stdenv, fetchurl, pkgconfig, gnutls, jansson, liburcu, lmdb, libcap_ng, libidn
, systemd, nettle, libedit, zlib, libiconv, fetchpatch
}:

let inherit (stdenv.lib) optional optionals; in

# Note: ATM only the libraries have been tested in nixpkgs.
stdenv.mkDerivation rec {
  name = "knot-dns-${version}";
  version = "2.5.1";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "1643q2pj5sjhgv19jp8r2bhvqyk6mmlajdmr6qhjcbhql30cs23c";
  };

  outputs = [ "bin" "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gnutls jansson liburcu libidn
    nettle libedit
    libiconv
    # without sphinx &al. for developer documentation
  ]
    # Use embedded lmdb there for now, as detection is broken on Darwin somehow.
    ++ optionals stdenv.isLinux [ libcap_ng systemd lmdb ]
    ++ optional stdenv.isDarwin zlib; # perhaps due to gnutls

  # Not ideal but seems to work on Linux.
  configureFlags = optional stdenv.isLinux "--with-lmdb=${stdenv.lib.getLib lmdb}";

  enableParallelBuilding = true;

  CFLAGS = [ "-O2" "-DNDEBUG" ];

  #doCheck = true; problems in combination with dynamic linking

  postInstall = ''rm -r "$out"/var'';

  meta = with stdenv.lib; {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = https://knot-dns.cz;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}

