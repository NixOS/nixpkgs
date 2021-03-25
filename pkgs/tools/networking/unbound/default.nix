{ stdenv
, lib
, fetchurl
, openssl
, nettle
, expat
, libevent
, dns-root-data
, pkg-config
  #
  # By default unbound will not be built with systemd support. Unbound is a very
  # commmon dependency. The transitive dependency closure of systemd also
  # contains unbound.
  # Since most (all?) (lib)unbound users outside of the unbound daemon usage do
  # not need the systemd integration it is likely best to just default to no
  # systemd integration.
  # For the daemon use-case, that needs to notify systemd, use `unbound-with-systemd`.
  #
, withSystemd ? false
, systemd ? null
  # optionally support DNS-over-HTTPS as a server
, withDoH ? false
, libnghttp2
}:

stdenv.mkDerivation rec {
  pname = "unbound";
  version = "1.13.0";

  src = fetchurl {
    url = "https://unbound.net/downloads/${pname}-${version}.tar.gz";
    sha256 = "18dj7migq6379hps59793457l81s3z7dll3y0fj6qcmhjlx08m59";
  };

  outputs = [ "out" "lib" "man" ]; # "dev" would only split ~20 kB

  buildInputs = [ openssl nettle expat libevent ]
    ++ lib.optionals withSystemd [ pkg-config systemd ]
    ++ lib.optionals withDoH [ libnghttp2 ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-libexpat=${expat.dev}"
    "--with-libevent=${libevent.dev}"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--sbindir=\${out}/bin"
    "--with-rootkey-file=${dns-root-data}/root.key"
    "--enable-pie"
    "--enable-relro-now"
  ] ++ lib.optional stdenv.hostPlatform.isStatic [
    "--disable-flto"
  ] ++ lib.optionals withSystemd [
    "--enable-systemd"
  ] ++ lib.optionals withDoH [
    "--with-libnghttp2=${libnghttp2.dev}"
  ];

  installFlags = [ "configfile=\${out}/etc/unbound/unbound.conf" ];

  postInstall = ''
    make unbound-event-install
  '';

  preFixup = lib.optionalString (stdenv.isLinux && !stdenv.hostPlatform.isMusl) # XXX: revisit
    # Build libunbound again, but only against nettle instead of openssl.
    # This avoids gnutls.out -> unbound.lib -> openssl.out.
    # There was some problem with this on Darwin; let's not complicate non-Linux.
    ''
      configureFlags="$configureFlags --with-nettle=${nettle.dev} --with-libunbound-only"
      configurePhase
      buildPhase
      installPhase
    ''
  # get rid of runtime dependencies on $dev outputs
  + ''substituteInPlace "$lib/lib/libunbound.la" ''
  + lib.concatMapStrings
    (pkg: lib.optionalString (pkg ? dev) " --replace '-L${pkg.dev}/lib' '-L${pkg.out}/lib' --replace '-R${pkg.dev}/lib' '-R${pkg.out}/lib'")
    (builtins.filter (p: p != null) buildInputs);

  meta = with lib; {
    description = "Validating, recursive, and caching DNS resolver";
    license = licenses.bsd3;
    homepage = "https://www.unbound.net";
    maintainers = with maintainers; [ ehmry fpletz globin ];
    platforms = platforms.unix;
  };
}
