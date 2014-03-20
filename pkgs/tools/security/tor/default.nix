{ stdenv, fetchurl, libevent, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "tor-0.2.3.25";

  src = fetchurl {
    url = "http://www.torproject.org/dist/${name}.tar.gz";
    sha256 = "bb2d6f1136f33e11d37e6e34184143bf191e59501613daf33ae3d6f78f3176a0";
  };

  buildInputs = [ libevent openssl zlib ];

  CFLAGS = "-lgcc_s";

  doCheck = true;

  meta = {
    homepage = http://www.torproject.org/;
    repositories.git = https://git.torproject.org/git/tor;
    description = "Tor, an anonymous network router to improve privacy on the Internet";

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

    maintainers = with stdenv.lib.maintainers; [ phreedom ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
