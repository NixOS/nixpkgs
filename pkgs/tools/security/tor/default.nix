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
  version = "0.4.6.8";

  src = fetchurl {
    url = "https://dist.torproject.org/${pname}-${version}.tar.gz";
    sha256 = "0sj7qn6d6js6gk4vjfkc7p9g021czbfaq00yfq3mn5ycnhvimkhm";
  };

  outputs = [ "out" "geoip" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libevent openssl zlib xz zstd scrypt ] ++
    lib.optionals stdenv.isLinux [ libseccomp systemd libcap ];

  patches = [ ./disable-monotonic-timer-tests.patch ];

  # cross compiles correctly but needs the following
  configureFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    "--disable-tool-name-check";

  NIX_CFLAGS_LINK = lib.optionalString stdenv.cc.isGNU "-lgcc_s";

  postPatch = ''
    substituteInPlace contrib/client-tools/torify \
      --replace 'pathfind torsocks' true          \
      --replace 'exec torsocks' 'exec ${torsocks}/bin/torsocks'

    patchShebangs ./scripts/maint/checkShellScripts.sh
  '';

  enableParallelBuilding = true;

  doCheck = true;

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
    repositories.git = "https://git.torproject.org/git/tor";
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
      [ phreedom thoughtpolice joachifm prusnak ];
    platforms = platforms.unix;
  };
}
