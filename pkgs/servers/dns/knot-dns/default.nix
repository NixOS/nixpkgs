{ stdenv, fetchurl, pkgconfig, gnutls, jansson, liburcu, lmdb, libcap_ng, libidn
, systemd, nettle, libedit, zlib, libiconv, libintlOrEmpty
, fetchpatch
}:

let inherit (stdenv.lib) optional optionals; in

# Note: ATM only the libraries have been tested in nixpkgs.
stdenv.mkDerivation rec {
  name = "knot-dns-${version}";
  version = "2.6.0";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "68e04961d0bf6ba193cb7ec658b295c4ff6e60b3754d64bcd77ebdcee0f283fd";
  };

  patches = [
    # remove both for >= 2.6.1
    (fetchpatch {
      name = "kdig-tls.patch";
      url = "https://gitlab.labs.nic.cz/knot/knot-dns/commit/b72d5cd032795.diff";
      sha256 = "0ig31rp82j49jh8n3s0dcf5abhh35mcp2k2wii7bh0c60ngb29k6";
    })
    (fetchpatch {
      name = "kdig-tls-sni.patch";
      url = "https://gitlab.labs.nic.cz/knot/knot-dns/commit/2e94ccee671ec70e.diff";
      sha256 = "0psl6650v7g240i8w196v7zxy6j11d0aa6hm11b7vnaimjshgibv";
    })
  ];

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
    ++ libintlOrEmpty
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

