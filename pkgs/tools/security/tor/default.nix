{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libevent,
  openssl,
  zlib,
  torsocks,
  libseccomp,
  systemd,
  libcap,
  xz,
  zstd,
  scrypt,
  nixosTests,
  writeShellScript,

  # for update.nix
  writeScript,
  common-updater-scripts,
  bash,
  coreutils,
  curl,
  gnugrep,
  gnupg,
  gnused,
  nix,
}:
let
  tor-client-auth-gen = writeShellScript "tor-client-auth-gen" ''
    PATH="${
      lib.makeBinPath [
        coreutils
        gnugrep
        openssl
      ]
    }"
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
  version = "0.4.8.17";

  src = fetchurl {
    url = "https://dist.torproject.org/${pname}-${version}.tar.gz";
    sha256 = "sha256-ebRyXh1LiHueaP0JsNIkN3fVzjzUceU4WDvPb52M21Y=";
  };

  outputs = [
    "out"
    "geoip"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      libevent
      openssl
      zlib
      xz
      zstd
      scrypt
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libseccomp
      systemd
      libcap
    ];

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
      lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
        "--disable-seccomp"
      ];

  NIX_CFLAGS_LINK = lib.optionalString stdenv.cc.isGNU "-lgcc_s";

  postPatch = ''
    substituteInPlace contrib/client-tools/torify \
      --replace 'pathfind torsocks' true          \
      --replace 'exec torsocks' 'exec ${torsocks}/bin/torsocks'

    patchShebangs ./scripts/maint/checkShellScripts.sh
  '';

  enableParallelBuilding = true;

  # disable tests on linux aarch32
  # https://gitlab.torproject.org/tpo/core/tor/-/issues/40912
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch32);

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

    license = with licenses; [
      bsd3
      gpl3Only
    ];

    maintainers = with maintainers; [
      thoughtpolice
      joachifm
      prusnak
    ];
    platforms = platforms.unix;
  };
}
