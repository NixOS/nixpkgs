{ stdenv, fetchurl, libevent, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "tor-0.2.5.10";

  src = fetchurl {
    url = "https://archive.torproject.org/tor-package-archive/${name}.tar.gz";
    sha256 = "0fx8qnwh2f8ykfx0np4hyznjfi4xfy96z59pk96y3zyjvjjh5pdk";
  };

  buildInputs = [ libevent openssl zlib ];

  CFLAGS = "-lgcc_s";

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

    maintainers = with stdenv.lib.maintainers; [ phreedom ludo doublec ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
