{stdenv, lib, fetchurl, autoPatchelfHook, makeWrapper, libcxx, libX11, libXt, libXdamage, glib, gtk3, dbus-glib, openssl }:
let
    metadata = lib.importJSON ./meta.json;
in
stdenv.mkDerivation rec {
    name = "replay-io";
    version = metadata.date + "-" + metadata.revision;
    binaryName = "replay";
    srcs = [
      (fetchurl metadata.replay)
      (fetchurl metadata.recordreplay-lib)
    ];
    sourceRoot = ".";
    unpackPhase = ''
      runHook preUnpack

      arr=($srcs)
      tar xf ''${arr[0]} --strip-components=1
      tar xzf ''${arr[1]}

      runHook postUnpack
    '';
    buildInputs = [
        autoPatchelfHook
        makeWrapper
        dbus-glib
        glib
        gtk3
        libX11
        libXdamage
        libXt
        libcxx
        openssl
    ];
    patchPhase = ''
        patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} ${binaryName}
    '';
    installPhase = ''
        mkdir -p $out
        cp -r * $out
        mkdir $out/bin
        makeWrapper $out/replay \
          $out/bin/replay-io \
          --set "RECORD_REPLAY_DRIVER" "$out/linux-recordreplay.so"
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
}
