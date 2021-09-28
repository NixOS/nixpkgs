{ lib, stdenv, fetchurl, pkg-config, libnfnetlink,
  libnetfilter_log, libnetfilter_conntrack, libnetfilter_acct,
  libmnl }:

stdenv.mkDerivation rec {
  pname = "ulogd";
  version = "2.0.7";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-mQoFSU2cFgKboKg/O3KU/AXHVlRrjWDRwVctwlJJqSs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libnfnetlink libnetfilter_log libnetfilter_conntrack libnetfilter_acct libmnl
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/ulogd -h > /dev/null
  '';

  meta = with lib; {
    description = "A userspace logging daemon for netfilter/iptables related logging";
    homepage = "https://www.netfilter.org/projects/ulogd/index.html";
    platforms = platforms.linux;
    maintainers = with maintainers; [ thomassdk ];
    license = licenses.gpl2;
    downloadPage = "https://www.netfilter.org/projects/ulogd/files/";
    longDescription = ''
      ulogd is a userspace logging daemon for netfilter/iptables related logging.
      This includes per-packet logging of security violations,
      per-packet logging for accounting, per-flow logging and flexible user-defined accounting.
    '';
  };
}
