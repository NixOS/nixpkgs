{ lib, stdenv, fetchurl, pkg-config, gnutls, liburcu, lmdb, libcap_ng, libidn2, libunistring
, systemd, nettle, libedit, zlib, libiconv, libintl, libmaxminddb, libbpf, nghttp2, libmnl
, autoreconfHook, nixosTests, knot-resolver
}:

stdenv.mkDerivation rec {
  pname = "knot-dns";
  version = "3.1.8";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "767e458a56277a1270b359294c3be6c63fd734884d62a045e01756a46507aa94";
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
  ] ++ lib.optionals stdenv.isLinux [
    libcap_ng systemd
    libbpf libmnl # XDP support (it's Linux kernel API)
  ] ++ lib.optional stdenv.isDarwin zlib; # perhaps due to gnutls

  enableParallelBuilding = true;

  CFLAGS = [ "-O2" "-DNDEBUG" ];

  doCheck = true;
  checkFlags = "V=1"; # verbose output in case some test fails
  doInstallCheck = true;

  postInstall = ''
    rm -r "$out"/lib/*.la
  '';

  passthru.tests = {
    inherit knot-resolver;
  } // lib.optionalAttrs stdenv.isLinux {
    inherit (nixosTests) knot;
  };

  meta = with lib; {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = "https://knot-dns.cz";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
