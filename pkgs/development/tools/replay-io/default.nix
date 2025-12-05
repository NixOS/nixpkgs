{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  autoPatchelfHook,
  makeWrapper,
  libcxx,
  libX11,
  libXt,
  libXdamage,
  glib,
  gtk3,
  dbus-glib,
  openssl,
  nodejs,
  zlib,
  fetchzip,
}:
let
  metadata = lib.importJSON ./meta.json;
in
rec {
  replay-recordreplay = stdenv.mkDerivation {
    pname = "replay-recordreplay";
    version = builtins.head (builtins.match ".*/linux-recordreplay-(.*).tgz" metadata.recordreplay.url);
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      (lib.getLib stdenv.cc.cc)
      openssl
      zlib
    ];

    src = (fetchzip metadata.recordreplay);
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      cp linux-recordreplay.so $out
      runHook postInstall
    '';
    postFixup = ''
      patchelf --set-rpath "$(patchelf --print-rpath $out):${lib.makeLibraryPath [ openssl ]}" $out
    '';
    meta = with lib; {
      description = "RecordReplay internal recording library";
      homepage = "https://www.replay.io/";
      license = lib.licenses.unfree;
      maintainers = with maintainers; [ phryneas ];
      platforms = [ "x86_64-linux" ];
    };
  };

  replay-io = stdenv.mkDerivation {
    pname = "replay-io";
    version = builtins.head (builtins.match ".*/linux-gecko-(.*).tar.bz2" metadata.replay.url);
    srcs = fetchurl metadata.replay;
    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];
    buildInputs = [
      dbus-glib
      glib
      gtk3
      libX11
      libXdamage
      libXt
    ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/replay-io
      cp -r * $out/opt/replay-io
      mkdir $out/bin
      makeWrapper $out/opt/replay-io/replay \
        $out/bin/replay-io \
        --set "RECORD_REPLAY_DRIVER" "${replay-recordreplay}"
      runHook postInstall
    '';

    passthru.updateScript = ./update.sh;

    meta = with lib; {
      description = "Time Travel Debugger for Web Development";
      longDescription = ''
        Replay allows you to record and replay web applications with familiar browser dev tools.
        You can access the browser DevTools at any point of the recording, adding new logger
        statements and inspecting the status of the DOM, variables and the current call stack.
        Your recordings can be shared with other users for collaborative debugging.
      '';
      homepage = "https://www.replay.io/";
      downloadPage = "https://www.replay.io/";
      mainProgram = "replay-io";
      license = lib.licenses.mpl20;
      maintainers = with maintainers; [ phryneas ];
      platforms = [ "x86_64-linux" ];
    };
  };

  replay-node = stdenv.mkDerivation {
    pname = "replay-node";
    version = builtins.head (builtins.match ".*/linux-node-(.*)" metadata.replay-node.url);
    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];
    buildInputs = [ (lib.getLib stdenv.cc.cc) ];

    src = (fetchurl metadata.replay-node);
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/opt/replay-node
      cp $src $out/opt/replay-node/node-unwrapped
      chmod +x $out/opt/replay-node/node-unwrapped

      makeWrapper $out/opt/replay-node/node-unwrapped \
        $out/opt/replay-node/node \
        --set "RECORD_REPLAY_DRIVER" "${replay-recordreplay}"

      ln -s $out/opt/replay-node/node $out/bin/replay-node
      runHook postInstall
    '';

    meta = with lib; {
      description = "Event-driven I/O framework for the V8 JavaScript engine, patched for replay";
      homepage = "https://github.com/RecordReplay/node";
      license = licenses.mit;
      maintainers = with maintainers; [ phryneas ];
      platforms = platforms.linux;
      mainProgram = "replay-node";
    };
  };

  replay-node-cli = stdenv.mkDerivation {
    pname = "replay-node-cli";
    version = "0.1.7-" + builtins.head (builtins.match ".*/linux-node-(.*)" metadata.replay-node.url);
    src = fetchFromGitHub {
      owner = "RecordReplay";
      repo = "replay-node-cli";
      rev = "5269c8b8e7c5c7a9618a68f883d19c11a68be837";
      sha256 = "04d22q3dvs9vxpb9ps64pdxq9ziwgvnzdgsn6p9p0lzjagh0f5n0";
    };

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [
      (lib.getLib stdenv.cc.cc)
      nodejs
    ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt/replay-node-cli
      cp -r * $out/opt/replay-node-cli
      makeWrapper $out/opt/replay-node-cli/bin/replay-node \
        $out/bin/replay-node \
        --prefix "PATH" ":" "${nodejs}/bin" \
        --set "RECORD_REPLAY_NODE_DIRECTORY" "${replay-node}/opt/replay-node"
      runHook postInstall
    '';

    meta = with lib; {
      description = "Time Travel Debugger for Web Development - Node Command Line";
      longDescription = ''
        The Replay Node Command Line allows you to record node applications and debug them
        with familiar browser dev tools.
        You can access the browser DevTools at any point of the recording, adding new logger
        statements and inspecting the status of variables and the current call stack.
        Your recordings can be shared with other users for collaborative debugging.
      '';
      homepage = "https://www.replay.io/";
      mainProgram = "replay-node";
      license = lib.licenses.bsd3;
      maintainers = with maintainers; [ phryneas ];
      platforms = [ "x86_64-linux" ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
}
