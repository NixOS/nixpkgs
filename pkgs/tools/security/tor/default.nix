{ lib, stdenv, fetchurl, pkg-config, libevent, openssl, zlib, torsocks
, libseccomp, systemd, libcap, xz, zstd, scrypt, nixosTests
, writeShellScript

# for update.nix
, writeScript
, common-updater-scripts
, bash
, coreutils
, curl
, gnugrep
, gnupg
, gnused
, nix
}:
let
  tor-client-auth-gen = writeShellScript "tor-client-auth-gen" ''
    PATH="${lib.makeBinPath [coreutils gnugrep openssl]}"
    pem="$(openssl genpkey -algorithm x25519)"

    printf private_key=descriptor:x25519:
    echo "$pem" | grep -v " PRIVATE KEY" |
    base64 -d | tail --bytes=32 | base32 | tr -d =

    printf public_key=descriptor:x25519:
    echo "$pem" | openssl pkey -in /dev/stdin -pubout |
    grep -v " PUBLIC KEY" |
    base64 -d | tail --bytes=32 | base32 | tr -d =
  '';
in
stdenv.mkDerivation rec {
  pname = "tor";
  version = "0.4.7.8";

  src = fetchurl {
    url = "https://dist.torproject.org/${pname}-${version}.tar.gz";
    sha256 = "sha256-nppcZ60qzdXw+L4U7Vkf7QdrFwir+DRAZpkKD6Zv4ZU=";
  };

  outputs = [ "out" "geoip" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl zlib xz zstd scrypt ] ++
    lib.optionals stdenv.isLinux [ libseccomp systemd libcap ];

  patches = [ ./disable-monotonic-timer-tests.patch ];

  configureFlags =
    # cross compiles correctly but needs the following
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "--disable-tool-name-check" ]
    ++
    # sandbox is broken on aarch64-linux https://gitlab.torproject.org/tpo/core/tor/-/issues/40599
    lib.optionals (stdenv.isLinux && stdenv.isAarch64) [ "--disable-seccomp" ]
  ;

  NIX_CFLAGS_LINK = lib.optionalString stdenv.cc.isGNU "-lgcc_s";

  postPatch = ''
    substituteInPlace contrib/client-tools/torify \
      --replace 'pathfind torsocks' true          \
      --replace 'exec torsocks' 'exec ${torsocks}/bin/torsocks'

    patchShebangs ./scripts/maint/checkShellScripts.sh
  '';

  enableParallelBuilding = true;

  # disable tests on aarch64-darwin, the following tests fail there:
  # oom/circbuf: [forking]
  #   FAIL src/test/test_oom.c:187: assert(c1->marked_for_close)
  #   [circbuf FAILED]
  # oom/streambuf: [forking]
  #   FAIL src/test/test_oom.c:287: assert(x_ OP_GE 500 - 5): 0 vs 495
  #   [streambuf FAILED]
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  postInstall = ''
    mkdir -p $geoip/share/tor
    mv $out/share/tor/geoip{,6} $geoip/share/tor
    rm -rf $out/share/tor
    ln -s ${tor-client-auth-gen} $out/bin/tor-client-auth-gen
  '';

  passthru = {
    tests.tor = nixosTests.tor;
    updateScript = import ./update.nix {
      inherit lib;
      inherit
        writeScript
        common-updater-scripts
        bash
        coreutils
        curl
        gnupg
        gnugrep
        gnused
        nix
      ;
    };
  };

  meta = with lib; {
    homepage = "https://www.torproject.org/";
    description = "Anonymizing overlay network";

    longDescription = ''
      Tor helps improve your privacy by bouncing your communications around a
      network of relays run by volunteers all around the world: it makes it
      harder for somebody watching your Internet connection to learn what sites
      you visit, and makes it harder for the sites you visit to track you. Tor
      works with many of your existing applications, including web browsers,
      instant messaging clients, remote login, and other applications based on
      the TCP protocol.
    '';

    license = licenses.bsd3;

    maintainers = with maintainers;
      [ thoughtpolice joachifm prusnak ];
    platforms = platforms.unix;
  };
}
