{ lib, stdenv, go, fetchurl, redo-apenwarr, curl, perl, genericUpdater
, writeShellScript, nixosTests, cfgPath ? "/etc/nncp.hjson" }:

stdenv.mkDerivation rec {
  pname = "nncp";
  version = "8.8.2";
  outputs = [ "out" "doc" "info" ];

  src = fetchurl {
    url = "http://www.nncpgo.org/download/${pname}-${version}.tar.xz";
    sha256 = "02B98DC4654C46328A043209CD2DA28BF33A53BAF15574429C6C0747AE2FCF39";
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
    versionLister = writeShellScript "nncp-versionLister" ''
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
    changelog = "http://www.nncpgo.org/News.html";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry woffs ];
  };
}
