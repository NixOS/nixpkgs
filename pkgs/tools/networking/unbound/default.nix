{ stdenv
, lib
, fetchurl
, openssl
, nettle
, expat
, libevent
, libsodium
, protobufc
, hiredis
, dns-root-data
, pkg-config
, makeWrapper
, symlinkJoin
, bison
, nixosTests
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
, withECS ? false
, withDNSCrypt ? false
, withDNSTAP ? false
, withTFO ? false
, withRedis ? false
# Avoid .lib depending on openssl.out
# The build gets a little hacky, so in some cases we disable this approach.
, withSlimLib ? stdenv.isLinux && !stdenv.hostPlatform.isMusl && !withDNSTAP
, libnghttp2
}:

stdenv.mkDerivation rec {
  pname = "unbound";
  version = "1.14.0";

  src = fetchurl {
    url = "https://nlnetlabs.nl/downloads/unbound/unbound-${version}.tar.gz";
    sha256 = "sha256-bvkcvwLVKZ6rOTKMCFc5Pee0iFov5yM93+PBJP9aicg=";
  };

  outputs = [ "out" "lib" "man" ]; # "dev" would only split ~20 kB

  nativeBuildInputs = [ makeWrapper ];

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
  ] ++ lib.optionals withECS [
    "--enable-subnet"
  ] ++ lib.optionals withDNSCrypt [
    "--enable-dnscrypt"
    "--with-libsodium=${symlinkJoin { name = "libsodium-full"; paths = [ libsodium.dev libsodium.out ]; }}"
  ] ++ lib.optionals withDNSTAP [
    "--enable-dnstap"
    "--with-protobuf-c=${protobufc}"
  ] ++ lib.optionals withTFO [
    "--enable-tfo-client"
    "--enable-tfo-server"
  ] ++ lib.optionals withRedis [
    "--enable-cachedb"
    "--with-libhiredis=${hiredis}"
  ];

  PROTOC_C = lib.optionalString withDNSTAP "${protobufc}/bin/protoc-c";

  # Remove references to compile-time dependencies that are included in the configure flags
  postConfigure = let
    inherit (builtins) storeDir;
  in ''
    sed -E '/CONFCMDLINE/ s;${storeDir}/[a-z0-9]{32}-;${storeDir}/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-;g' -i config.h
  '';

  checkInputs = [ bison ];

  doCheck = true;

  installFlags = [ "configfile=\${out}/etc/unbound/unbound.conf" ];

  postInstall = ''
    make unbound-event-install
    wrapProgram $out/bin/unbound-control-setup \
      --prefix PATH : ${lib.makeBinPath [ openssl ]}
  '';

  preFixup = lib.optionalString withSlimLib
    # Build libunbound again, but only against nettle instead of openssl.
    # This avoids gnutls.out -> unbound.lib -> openssl.out.
    ''
      configureFlags="$configureFlags --with-nettle=${nettle.dev} --with-libunbound-only"
      configurePhase
      buildPhase
      if [ -n "$doCheck" ]; then
          checkPhase
      fi
      installPhase
    ''
  # get rid of runtime dependencies on $dev outputs
  + ''substituteInPlace "$lib/lib/libunbound.la" ''
  + lib.concatMapStrings
    (pkg: lib.optionalString (pkg ? dev) " --replace '-L${pkg.dev}/lib' '-L${pkg.out}/lib' --replace '-R${pkg.dev}/lib' '-R${pkg.out}/lib'")
    (builtins.filter (p: p != null) buildInputs);

  passthru.tests = nixosTests.unbound;

  meta = with lib; {
    description = "Validating, recursive, and caching DNS resolver";
    license = licenses.bsd3;
    homepage = "https://www.unbound.net";
    maintainers = with maintainers; [ fpletz globin ];
    platforms = platforms.unix;
  };
}
