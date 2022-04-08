{ stdenv, lib, fetchurl, fetchgit, autoPatchelfHook, makeWrapper, libcxx, libX11
, libXt, libXdamage, glib, gtk3, dbus-glib, openssl, nodejs, zlib }:
let metadata = lib.importJSON ./meta.json;
in rec {
  replay-recordreplay = stdenv.mkDerivation rec {
    name = "replay-recordreplay";
    version = builtins.head (builtins.match ".*/linux-recordreplay-(.*).tgz"
      metadata.recordreplay.url);
    buildInputs = [ autoPatchelfHook stdenv.cc.cc.lib openssl zlib ];

    src = (fetchurl metadata.recordreplay);
    unpackPhase = ''
      tar xzf $src
    '';
    dontBuild = true;
    installPhase = ''
      cp linux-recordreplay.so $out
    '';
  };

  replay-io = stdenv.mkDerivation rec {
    name = "replay-io";
    version = builtins.head
      (builtins.match ".*/linux-gecko-(.*).tar.bz2" metadata.replay.url);
    srcs = fetchurl metadata.replay;
    buildInputs = [
      autoPatchelfHook
      makeWrapper
      dbus-glib
      glib
      gtk3
      libX11
      libXdamage
      libXt
    ];
    patchPhase = ''
      patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} replay
    '';
    installPhase = ''
      mkdir -p $out/opt/replay-io
      cp -r * $out/opt/replay-io
      mkdir $out/bin
      makeWrapper $out/opt/replay-io/replay \
        $out/bin/replay-io \
        --set "RECORD_REPLAY_DRIVER" "${replay-recordreplay}"
    '';

    passthru.updateScript = ./update.sh;

    meta = with lib; {
      description = "The Time Travel Debugger for Web Development";
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

  replay-node = stdenv.mkDerivation rec {
    name = "replay-node";
    version = builtins.head
      (builtins.match ".*/linux-node-(.*)" metadata.replay-node.url);
    buildInputs = [ makeWrapper autoPatchelfHook stdenv.cc.cc.lib ];

    src = (fetchurl metadata.replay-node);
    dontUnpack = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin $out/opt/replay-node
      cp $src $out/opt/replay-node/node-unwrapped
      chmod +x $out/opt/replay-node/node-unwrapped

      makeWrapper $out/opt/replay-node/node-unwrapped \
        $out/opt/replay-node/node \
        --set "RECORD_REPLAY_DRIVER" "${replay-recordreplay}"

      ln -s $out/opt/replay-node/node $out/bin/replay-node
    '';
  };

  replay-node-cli = stdenv.mkDerivation {
    name = "replay-node-cli";
    version = builtins.head
      (builtins.match ".*/linux-node-(.*)" metadata.replay-node.url);
    src = fetchgit {
      url = "https://github.com/RecordReplay/replay-node-cli";
      rev = "48ebf1c419285dc623ee4a78bce491cc12b64e64";
      sha256 = "00g8q3cp5x3rca6rgdkmn266s52wgr0s3y1wmqphsgyag9pcnxz0";
    };
    patches = ./replay-node-cli.patch;

    buildInputs = [ makeWrapper stdenv.cc.cc.lib nodejs ];
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/opt/replay-node-cli
      cp -r * $out/opt/replay-node-cli
      makeWrapper $out/opt/replay-node-cli/src/bin.js \
        $out/bin/replay-node \
        --prefix "PATH" ":" "${nodejs}/bin" \
        --set "REPLAY_NODE_DIR" "${replay-node}/opt/replay-node" \
    '';
  };
}
