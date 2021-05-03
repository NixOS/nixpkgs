{ stdenv, fetchurl, pkgconfig, libevent, openssl, zlib, torsocks
, libseccomp, systemd, libcap, lzma, zstd, scrypt, nixosTests

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

stdenv.mkDerivation rec {
  pname = "tor";
  version = "0.4.4.8";

  src = fetchurl {
    url = "https://dist.torproject.org/${pname}-${version}.tar.gz";
    sha256 = "0ivmrdb8gw105lm2ybd0cja0cni0apb8akx4gn3z8irds8w1dbac";
  };

  outputs = [ "out" "geoip" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libevent openssl zlib lzma zstd scrypt ] ++
    stdenv.lib.optionals stdenv.isLinux [ libseccomp systemd libcap ];

  patches = [ ./disable-monotonic-timer-tests.patch ];

  # cross compiles correctly but needs the following
  configureFlags = stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    "--disable-tool-name-check";

  NIX_CFLAGS_LINK = stdenv.lib.optionalString stdenv.cc.isGNU "-lgcc_s";

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
  '';

  passthru = {
    tests.tor = nixosTests.tor;
    updateScript = import ./update.nix {
      inherit (stdenv) lib;
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

  meta = with stdenv.lib; {
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
