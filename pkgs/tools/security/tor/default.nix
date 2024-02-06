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
  version = "0.4.8.10";

  src = fetchurl {
    url = "https://dist.torproject.org/${pname}-${version}.tar.gz";
    sha256 = "sha256-5ii0+rcO20cncVsjzykxN1qfdoWsCPLFnqSYoXhGOoY=";
  };

  outputs = [ "out" "geoip" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl zlib xz zstd scrypt ] ++
    lib.optionals stdenv.isLinux [ libseccomp systemd libcap ];

  patches = [ ./disable-monotonic-timer-tests.patch ];

  configureFlags =
    # allow inclusion of GPL-licensed code (needed for Proof of Work defense for onion services)
    # for more details see
    # https://gitlab.torproject.org/tpo/onion-services/onion-support/-/wikis/Documentation/PoW-FAQ#compiling-c-tor-with-the-pow-defense
    [ "--enable-gpl" ]
    ++
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
  # disable tests on aarch32, the following tests fail there:
  # sandbox/is_active: [forking] Feb 06 17:43:14.224 [err] install_syscall_filter(): Bug: (Sandbox) failed to load: -125 (Operation canceled)! Are you sure that your kernel has seccomp2 support? The sandbox won't work without it. (on Tor 0.4.8.10 )
  #   FAIL src/test/test_sandbox.c:146: assert(sandbox_is_active())
  #   [is_active FAILED]
  # sandbox/open_filename: [forking] Feb 06 17:43:14.279 [err] install_syscall_filter(): Bug: (Sandbox) failed to load: -125 (Operation canceled)! Are you sure that your kernel has seccomp2 support? The sandbox won't work without it. (on Tor 0.4.8.10 )
  #   FAIL src/test/test_sandbox.c:170: assert(fd OP_EQ -1): 9 vs -1
  #   [open_filename FAILED]
  # sandbox/opendir_dirname: [forking] Feb 06 17:43:14.343 [err] install_syscall_filter(): Bug: (Sandbox) failed to load: -125 (Operation canceled)! Are you sure that your kernel has seccomp2 support? The sandbox won't work without it. (on Tor 0.4.8.10 )
  #   FAIL src/test/test_sandbox.c:271: assert(dir OP_EQ NULL): 0xdf8300 vs (nil)
  #   [opendir_dirname FAILED]
  # sandbox/openat_filename: [forking] Feb 06 17:43:14.400 [err] install_syscall_filter(): Bug: (Sandbox) failed to load: -125 (Operation canceled)! Are you sure that your kernel has seccomp2 support? The sandbox won't work without it. (on Tor 0.4.8.10 )
  #   FAIL src/test/test_sandbox.c:249: assert(fd OP_EQ -1): 9 vs -1
  #   [openat_filename FAILED]
  # sandbox/chmod_filename: [forking] Feb 06 17:43:14.493 [err] install_syscall_filter(): Bug: (Sandbox) failed to load: -125 (Operation canceled)! Are you sure that your kernel has seccomp2 support? The sandbox won't work without it. (on Tor 0.4.8.10 )
  #   FAIL src/test/test_sandbox.c:190: assert(rc OP_EQ -1): 0 vs -1
  #   [chmod_filename FAILED]
  # sandbox/chown_filename: [forking] Feb 06 17:43:14.561 [err] install_syscall_filter(): Bug: (Sandbox) failed to load: -125 (Operation canceled)! Are you sure that your kernel has seccomp2 support? The sandbox won't work without it. (on Tor 0.4.8.10 )
  #   FAIL src/test/test_sandbox.c:208: assert(rc OP_EQ -1): 0 vs -1
  #   [chown_filename FAILED]
  # sandbox/rename_filename: [forking] Feb 06 17:43:14.629 [err] install_syscall_filter(): Bug: (Sandbox) failed to load: -125 (Operation canceled)! Are you sure that your kernel has seccomp2 support? The sandbox won't work without it. (on Tor 0.4.8.10 )
  #   FAIL src/test/test_sandbox.c:228: assert(rc OP_EQ -1): 0 vs -1
  #   [rename_filename FAILED]

  doCheck = !(stdenv.isDarwin && stdenv.isAarch64) && !(stdenv.isLinux && stdenv.isAarch32);

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

    license = with licenses; [ bsd3 gpl3Only ];

    maintainers = with maintainers;
      [ thoughtpolice joachifm prusnak ];
    platforms = platforms.unix;
  };
}
