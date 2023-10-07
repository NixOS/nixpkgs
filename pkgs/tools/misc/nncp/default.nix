{ cfgPath ? "/etc/nncp.hjson"
, curl
, fetchurl
, lib
, genericUpdater
, go
, perl
, stdenv
, writeShellScript
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nncp";
  version = "8.9.0";
  outputs = [ "out" "doc" "info" ];

  src = fetchurl {
    url = "http://www.nncpgo.org/download/nncp-${finalAttrs.version}.tar.xz";
    hash = "sha256-JZ+svDNU7cwW58ZOJ4qszbR/+j7Cr+oLNig/RqqCS10=";
  };

  nativeBuildInputs = [
    go
  ];

  # Build parameters
  CFGPATH = cfgPath;
  SENDMAIL = "sendmail";

  preConfigure = "export GOCACHE=$NIX_BUILD_TOP/gocache";

  buildPhase = ''
    runHook preBuild
    ./bin/build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=$out ./install
    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.updateScript = genericUpdater {
    versionLister = writeShellScript "nncp-versionLister" ''
      ${curl}/bin/curl -s ${finalAttrs.meta.downloadPage} | ${perl}/bin/perl -lne 'print $1 if /Release.*>([0-9.]+)</'
    '';
  };

  meta = {
    broken = stdenv.isDarwin;
    changelog = "http://www.nncpgo.org/News.html";
    description = "Secure UUCP-like store-and-forward exchanging";
    downloadPage = "http://www.nncpgo.org/Tarballs.html";
    homepage = "http://www.nncpgo.org/";
    license = lib.licenses.gpl3Only;
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
    maintainers = with lib.maintainers; [ ehmry woffs ];
    platforms = lib.platforms.all;
  };
})
