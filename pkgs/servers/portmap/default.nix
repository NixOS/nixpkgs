{ fetchurl, stdenv, lib, tcpWrapper
, daemonUser ? false, daemonUID ? false, daemonGID ? false }:

assert daemonUser -> (!daemonUID && !daemonGID);

stdenv.mkDerivation rec {
  name = "portmap-6.0";
  
  src = fetchurl {
    url = "http://neil.brown.name/portmap/${name}.tgz";
    sha256 = "1pj13ll4mbfwjwpn3fbg03qq9im6v2i8fcpa3ffp4viykz9j1j02";
  };

  patches = [ ./reuse-socket.patch ];

  postPatch = ''
    substituteInPlace "Makefile" --replace "/usr/share" "" \
      --replace "install -o root -g root" "install"
  '';

  makeFlags =
    lib.optional (daemonUser != false) "RPCUSER=\"${daemonUser}\""
    ++ lib.optional (daemonUID != false) "DAEMON_UID=${toString daemonUID}"
    ++ lib.optional (daemonGID != false) "DAEMON_GID=${toString daemonGID}";

  buildInputs = [ tcpWrapper ];

  installPhase = ''
    mkdir -p "$out/sbin" "$out/man/man8"
    make install BASEDIR=$out
  '';

  meta = {
    description = "ONC RPC portmapper";
    longDescription = ''
      Portmap is part of the ONC RPC software collection implementing
      remote procedure calls (RPCs) between computer programs.  It is
      widely used by NFS and NIS, among others.
    '';

    homepage = http://neil.brown.name/portmap/;
    license = "BSD";
  };
}
