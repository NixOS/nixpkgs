{ lib, stdenv, fetchFromGitHub, libpcap, withTcl ? true, tcl }:

stdenv.mkDerivation rec {
  pname = "hping";
  version = "2014-12-26";

  src = fetchFromGitHub {
    owner = "antirez";
    repo = pname;
    rev = "3547c7691742c6eaa31f8402e0ccbb81387c1b99"; # there are no tags/releases
    sha256 = "0y0n1ybij3yg9lfgzcwfmjz1sjg913zcqrv391xx83dm0j80sdpb";
  };

  buildInputs = [ libpcap ] ++ lib.optional withTcl tcl;

  postPatch = ''
    substituteInPlace Makefile.in --replace "gcc" "$CC"
    substituteInPlace version.c --replace "RELEASE_DATE" "\"$version\""
  '' + lib.optionalString stdenv.isLinux ''
    sed -i -e 's|#include <net/bpf.h>|#include <pcap/bpf.h>|' \
      libpcap_stuff.c script.c
  '';

  configureFlags = [ (if withTcl then "TCLSH=${tcl}/bin/tclsh" else "--no-tcl") ];

  installPhase = ''
    install -Dm755 hping3 -t $out/sbin
    ln -s $out/sbin/hping3 $out/sbin/hping
    ln -s $out/sbin/hping3 $out/sbin/hping2
    install -Dm644 docs/hping3.8 -t $out/share/man/man8
    ln -s hping3.8.gz $out/share/man/man8/hping.8.gz
    ln -s hping3.8.gz $out/share/man/man8/hping2.8.gz
  '';

  meta = with lib; {
    description = "A command-line oriented TCP/IP packet assembler/analyzer";
    homepage = "http://www.hping.org/";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
  };
}
