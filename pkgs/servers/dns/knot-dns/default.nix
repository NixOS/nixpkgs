{ lib, stdenv, fetchurl, pkg-config, gnutls, liburcu, lmdb, libcap_ng, libidn2, libunistring
, systemd, nettle, libedit, zlib, libiconv, libintl, libmaxminddb, libbpf, nghttp2
, autoreconfHook
}:

let inherit (lib) optional optionals; in

stdenv.mkDerivation rec {
  pname = "knot-dns";
  version = "3.0.4";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "451d8913a769b7e4bcb3e250a3181b448e28a82cfc58cea6f2509475d7327983";
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

  nativeBuildInputs = [ pkg-config autoreconfHook ];
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

  meta = with lib; {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = "https://knot-dns.cz";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
