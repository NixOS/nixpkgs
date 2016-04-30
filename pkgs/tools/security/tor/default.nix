{ stdenv, fetchurl, libevent, openssl, zlib, torsocks, libseccomp }:

stdenv.mkDerivation rec {
  name = "tor-0.2.7.6";

  src = fetchurl {
    url = "https://archive.torproject.org/tor-package-archive/${name}.tar.gz";
    sha256 = "0p8hjlfi8dwghlyjif5s0q98cmpgz9kn9jja25430l04z5wqcfj9";
  };

  # Note: torsocks is specified as a dependency, as the distributed
  # 'torify' wrapper attempts to use it; although there is no
  # ./configure time check for any of this.
  buildInputs = [ libevent openssl zlib torsocks ] ++
    stdenv.lib.optional stdenv.isLinux libseccomp;

  NIX_CFLAGS_LINK = stdenv.lib.optionalString stdenv.cc.isGNU "-lgcc_s";

  # Patch 'torify' to point directly to torsocks.
  patchPhase = ''
    substituteInPlace contrib/client-tools/torify \
      --replace 'pathfind torsocks' true          \
      --replace 'exec torsocks' 'exec ${torsocks}/bin/torsocks'
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.torproject.org/;
    repositories.git = https://git.torproject.org/git/tor;
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
      [ phreedom doublec thoughtpolice joachifm ];
    platforms = platforms.unix;
  };
}
