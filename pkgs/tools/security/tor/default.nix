{ stdenv, fetchurl, pkgconfig, libevent, openssl, zlib, torsocks
, libseccomp, systemd, libcap
}:

stdenv.mkDerivation rec {
  name = "tor-0.2.9.10";

  src = fetchurl {
    url = "https://dist.torproject.org/${name}.tar.gz";
    sha256 = "0h8kpn42mgpkzmnga143hi8nh0ai65ypxh7qhkwbb15j3wz2h4fn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libevent openssl zlib ] ++
    stdenv.lib.optionals stdenv.isLinux [ libseccomp systemd libcap ];

  NIX_CFLAGS_LINK = stdenv.lib.optionalString stdenv.cc.isGNU "-lgcc_s";

  postPatch = ''
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
