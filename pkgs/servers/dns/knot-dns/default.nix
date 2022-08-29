{ lib, stdenv, fetchurl, pkg-config, gnutls, liburcu, lmdb, libcap_ng, libidn2, libunistring
, systemd, nettle, libedit, zlib, libiconv, libintl, libmaxminddb, libbpf, nghttp2, libmnl
, autoreconfHook, nixosTests, knot-resolver
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "knot-dns";
  version = "3.2.0";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "426d120994daf93af348aa6c48428e583dd286656415de4daf7a59106fd98631";
  };

  outputs = [ "bin" "out" "dev" ];

  configureFlags = [
    "--with-configdir=/etc/knot"
    "--with-rundir=/run/knot"
    "--with-storage=/var/lib/knot"
  ];

  patches = [
    (fetchpatch {
      name = "test-32bit-xdp.patch";
      url = "https://gitlab.nic.cz/knot/knot-dns/-/commit/325dfeefdfd8a3dd318cfe0ab52cd7efbf839ccd.diff";
      sha256 = "E5J2Jf4/m5H59Xn6TyATu2gKs3CgShYlMF2Qj1SW1zw=";
    })
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
