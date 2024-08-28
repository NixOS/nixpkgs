{ lib, stdenv, fetchurl, pkg-config, gnutls, liburcu, lmdb, libcap_ng, libidn2, libunistring
, systemd, nettle, libedit, zlib, libiconv, libintl, libmaxminddb, libbpf, nghttp2, libmnl
, ngtcp2-gnutls, xdp-tools
, autoreconfHook
, nixosTests, knot-resolver, knot-dns, runCommandLocal
}:

stdenv.mkDerivation rec {
  pname = "knot-dns";
  version = "3.3.9";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "7cf2bd93bf487179aca1d2acf7b462dc269e769944c3ea73c7f9a4570dde86ab";
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
    ngtcp2-gnutls  # DoQ support in kdig (and elsewhere but not much use there yet)
    libmaxminddb # optional for geoip module (it's tiny)
    # without sphinx &al. for developer documentation
    # TODO: add dnstap support?
  ] ++ lib.optionals stdenv.isLinux [
    libcap_ng systemd
    xdp-tools libbpf libmnl # XDP support (it's Linux kernel API)
  ] ++ lib.optional stdenv.isDarwin zlib; # perhaps due to gnutls

  enableParallelBuilding = true;

  CFLAGS = [ "-O2" "-DNDEBUG" ];

  doCheck = true;
  checkFlags = [ "V=1" ]; # verbose output in case some test fails
  doInstallCheck = true;

  postInstall = ''
    rm -r "$out"/lib/*.la
  '';

  passthru.tests = {
    inherit knot-resolver;
  } // lib.optionalAttrs stdenv.isLinux {
    inherit (nixosTests) knot kea;
    prometheus-exporter = nixosTests.prometheus-exporters.knot;
    # Some dependencies are very version-sensitive, so the might get dropped
    # or embedded after some update, even if the nixPackagers didn't intend to.
    # For non-linux I don't know a good replacement for `ldd`.
    deps = runCommandLocal "knot-deps-test"
      { nativeBuildInputs = [ (lib.getBin stdenv.cc.libc) ]; }
      ''
        for libname in libngtcp2 libxdp libbpf; do
          echo "Checking for $libname:"
          ldd '${knot-dns.bin}/bin/knotd' | grep -F "$libname"
          echo "OK"
        done
        touch "$out"
      '';
  };

  meta = with lib; {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = "https://knot-dns.cz";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
    mainProgram = "knotd";
  };
}
