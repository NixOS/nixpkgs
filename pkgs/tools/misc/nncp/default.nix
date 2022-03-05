{ lib, stdenv, go, fetchurl, redo-apenwarr, curl, perl, genericUpdater
, writeShellScript, nixosTests, cfgPath ? "/etc/nncp.hjson" }:

stdenv.mkDerivation rec {
  pname = "nncp";
  version = "8.6.0";
  outputs = [ "out" "doc" "info" ];

  src = fetchurl {
    url = "http://www.nncpgo.org/download/${pname}-${version}.tar.xz";
    sha256 = "sha256-rhbwoJwbfR2jdn4cD0ENnCmsyuYypEipVdtKDxW/g48=";
  };

  nativeBuildInputs = [ go redo-apenwarr ];

  # Build parameters
  CFGPATH = cfgPath;
  SENDMAIL = "sendmail";

  preConfigure = "export GOCACHE=$NIX_BUILD_TOP/gocache";

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
      ${curl}/bin/curl -s ${meta.downloadPage} | ${perl}/bin/perl -lne 'print $1 if /Release.*>([0-9.]+)</'
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
    downloadPage = "http://www.nncpgo.org/Tarballs.html";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry woffs ];
  };
}
