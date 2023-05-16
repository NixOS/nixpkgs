<<<<<<< HEAD
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
=======
{ lib, stdenv, go, fetchurl, redo-apenwarr, curl, perl, genericUpdater
, writeShellScript, nixosTests, cfgPath ? "/etc/nncp.hjson" }:

stdenv.mkDerivation rec {
  pname = "nncp";
  version = "8.8.3";
  outputs = [ "out" "doc" "info" ];

  src = fetchurl {
    url = "http://www.nncpgo.org/download/${pname}-${version}.tar.xz";
    hash = "sha256-IldQCEdH6XDYK+DW5lB/5HFFFGuq1nDkCwEaVo7vIvE=";
  };

  nativeBuildInputs = [ go redo-apenwarr ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Build parameters
  CFGPATH = cfgPath;
  SENDMAIL = "sendmail";

  preConfigure = "export GOCACHE=$NIX_BUILD_TOP/gocache";

<<<<<<< HEAD
  buildPhase = ''
    runHook preBuild
    ./bin/build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    PREFIX=$out ./install
=======
  installPhase = ''
    runHook preInstall
    export PREFIX=$out
    rm -f INSTALL # work around case insensitivity
    redo install
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.updateScript = genericUpdater {
    versionLister = writeShellScript "nncp-versionLister" ''
<<<<<<< HEAD
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
=======
      ${curl}/bin/curl -s ${meta.downloadPage} | ${perl}/bin/perl -lne 'print $1 if /Release.*>([0-9.]+)</'
    '';
  };

  meta = with lib; {
    description = "Secure UUCP-like store-and-forward exchanging";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ ehmry woffs ];
    platforms = lib.platforms.all;
  };
})
=======
    homepage = "http://www.nncpgo.org/";
    downloadPage = "http://www.nncpgo.org/Tarballs.html";
    changelog = "http://www.nncpgo.org/News.html";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry woffs ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
