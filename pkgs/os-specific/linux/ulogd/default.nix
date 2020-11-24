{ stdenv, fetchurl, gnumake, libnetfilter_acct, libnetfilter_conntrack,
libnetfilter_log, libmnl, libnfnetlink, automake, autoconf, autogen, libtool,
pkg-config, libpcap, linuxdoc-tools, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "2.0.7";
  pname = "ulogd";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "0ax9959c4bapq78n13bbaibcf1gwjir3ngx8l2dh45lw9m4ha2lr";
  };

  outputs = [ "out" "doc" "man"];

  prePath = ''
    substituteInPlace ulogd.8 --replace "/usr/share/doc" "$doc/share/doc"
  '';

  postBuild = ''
    pushd doc/
    linuxdoc --backend=txt --filter ulogd.sgml
    linuxdoc --backend=html --split=0 ulogd.sgml
    popd
  '';

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} ulogd.conf doc/ulogd.txt doc/ulogd.html README doc/*table
    install -Dm444 -t $out/share/doc/${pname}-mysql doc/mysql*.sql
    install -Dm444 -t $out/share/doc/${pname}-pgsql doc/pgsql*.sql
  '';

  buildInputs = [
    libnetfilter_acct libnetfilter_conntrack libnetfilter_log libmnl
    libnfnetlink libpcap
  ];

  nativeBuildInputs = [
    autoreconfHook gnumake pkg-config automake autoconf autogen libtool
    linuxdoc-tools
  ];

  meta = with stdenv.lib; {
    description = "Userspace logging daemon for netfilter/iptables";

    longDescription =
    '' Logging daemon that reads event messages coming from the Netfilter
       connection tracking, the Netfilter packet logging subsystem and from the
       Netfilter accounting subsystem. You have to enable support for connection
       tracking event delivery; ctnetlink and the NFLOG target in your Linux
       kernel 2.6.x or load their respective modules. The deprecated ULOG target
       (which has been superseded by NFLOG) is also supported.

       The received messages can be logged into files or into a mySQL, sqlite3
       or PostgreSQL database. IPFIX and Graphite output are also supported.
    '';

    homepage = "https://www.netfilter.org/projects/ulogd/index.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xvuko ];
  };
}
