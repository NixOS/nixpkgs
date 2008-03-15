{ fetchurl, stdenv, lib, tcpWrapper
, daemonUser, daemonUID, daemonGID }:

assert daemonUser -> (!daemonUID && !daemonGID);

stdenv.mkDerivation rec {
  name = "portmap-6.0";
  src = fetchurl {
    url = "http://neil.brown.name/portmap/${name}.tgz";
    sha256 = "1pj13ll4mbfwjwpn3fbg03qq9im6v2i8fcpa3ffp4viykz9j1j02";
  };

  patchPhase = ''
    substituteInPlace "Makefile" --replace "/usr/share" "" \
      --replace "install -o root -g root" "install"
  '';

  makeFlags =
   lib.concatStringsSep " "
     (lib.optional (daemonUser != false) "RPCUSER=\"${daemonUser}\""
      ++ lib.optional (daemonUID != false) "DAEMON_UID=${toString daemonUID}"
      ++ lib.optional (daemonGID != false) "DAEMON_GID=${toString daemonGID}");

  buildInputs = [ tcpWrapper ];

  installPhase = ''
    ensureDir "$out/sbin" && ensureDir "$out/man/man8" && \
    make install BASEDIR=$out
  '';

  meta = {
    description = ''portmap is a part of the ONC RPC software collection
                    implementing remote procedure calls (RPCs) between
		    computer programs.  It is widely used by NFS and NIS,
		    among others.'';
    homepage = http://neil.brown.name/portmap/;
    license = "BSD";
  };
}
