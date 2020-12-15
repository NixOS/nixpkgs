{ stdenv, fetchurl, pkgconfig, gnutls, liburcu, lmdb, libcap_ng, libidn2, libunistring
, systemd, nettle, libedit, zlib, libiconv, libintl, libmaxminddb, libbpf, nghttp2
, autoreconfHook
}:

let inherit (stdenv.lib) optional optionals; in

stdenv.mkDerivation rec {
  pname = "knot-dns";
  version = "3.0.3";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "fbc51897ef0ed0639ebad59b988a91382b9544288a2db8254f0b1de433140e38";
  };

  outputs = [ "bin" "out" "dev" ];

  configureFlags = [
    "--with-configdir=/etc/knot"
    "--with-rundir=/run/knot"
    "--with-storage=/var/lib/knot"
  ];

  patches = [
    # Don't try to create directories like /var/lib/knot at build time.
    # They are later created from NixOS itself.
    ./dont-create-run-time-dirs.patch
    ./runtime-deps.patch
  ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    gnutls liburcu libidn2 libunistring
    nettle libedit
    libiconv lmdb libintl
    nghttp2 # DoH support in kdig
    libmaxminddb # optional for geoip module (it's tiny)
    # without sphinx &al. for developer documentation
    # TODO: add dnstap support?
  ]
    ++ optionals stdenv.isLinux [
      libcap_ng systemd
      libbpf # XDP support
    ]
    ++ optional stdenv.isDarwin zlib; # perhaps due to gnutls

  enableParallelBuilding = true;

  CFLAGS = [ "-O2" "-DNDEBUG" ];

  doCheck = true;
  doInstallCheck = true;

  postInstall = ''
    rm -r "$out"/lib/*.la
  '';

  meta = with stdenv.lib; {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = "https://knot-dns.cz";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
