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

  meta = {
    homepage = http://www.torproject.org/;
    repositories.git = https://git.torproject.org/git/tor;
    description = "Anonymous network router to improve privacy on the Internet";

    longDescription=''
      Tor protects you by bouncing your communications around a distributed
      network of relays run by volunteers all around the world: it prevents
      somebody watching your Internet connection from learning what sites you
      visit, and it prevents the sites you visit from learning your physical
      location. Tor works with many of your existing applications, including
      web browsers, instant messaging clients, remote login, and other
      applications based on the TCP protocol.
    '';

    license="mBSD";

    maintainers = with stdenv.lib.maintainers;
      [ phreedom doublec thoughtpolice ];
    platforms = stdenv.lib.platforms.unix;
  };
}
