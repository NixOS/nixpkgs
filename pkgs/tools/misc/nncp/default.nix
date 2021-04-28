{ lib, stdenv
, go
, fetchurl
, redo-apenwarr
, curl
, perl
, genericUpdater
, writeShellScript
}:

stdenv.mkDerivation rec {
  pname = "nncp";
  version = "6.4.0";

  src = fetchurl {
    url = "http://www.nncpgo.org/download/${pname}-${version}.tar.xz";
    sha256 = "16xrwhr7avss238k83ih1njl0gfca57ghg360ba9ixlssrb1239x";
  };

  nativeBuildInputs = [ go redo-apenwarr ];

  buildPhase = ''
    runHook preBuild
    export GOCACHE=$PWD/.cache
    export CFGPATH=/etc/nncp.hjson
    export SENDMAIL=sendmail # default value for generated config file
    redo ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    export PREFIX=$out
    rm -f INSTALL # work around case insensitivity
    redo install
    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.updateScript = genericUpdater {
    inherit pname version;
    versionLister = writeShellScript "nncp-versionLister" ''
      echo "# Versions for $1:" >> "$2"
      ${curl}/bin/curl -s http://www.nncpgo.org/Tarballs.html | ${perl}/bin/perl -lne 'print $1 if /Release.*>([0-9.]+)</'
    '';
  };

  meta = with lib; {
    description = "Secure UUCP-like store-and-forward exchanging";
    longDescription = ''
      This utilities are intended to help build up small size (dozens of
      nodes) ad-hoc friend-to-friend (F2F) statically routed darknet
      delay-tolerant networks for fire-and-forget secure reliable files,
      file requests, Internet mail and commands transmission. All
      packets are integrity checked, end-to-end encrypted, explicitly
      authenticated by known participants public keys. Onion encryption
      is applied to relayed packets. Each node acts both as a client and
      server, can use push and poll behaviour model.

      Out-of-box offline sneakernet/floppynet, dead drops, sequential
      and append-only CD-ROM/tape storages, air-gapped computers
      support. But online TCP daemon with full-duplex resumable data
      transmission exists.
    '';
    homepage = "http://www.nncpgo.org/";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.woffs ];
  };
}
