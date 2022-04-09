{ alsa-lib
, alsa-utils
, autoPatchelfHook
, fetchurl
, ffmpeg
, lib
, makeWrapper
, openssl
, stdenv
, zlib
}:
stdenv.mkDerivation rec {
  pname = "roon-bridge";
  version = "1.8-918";

  src =
    let
      urlVersion = builtins.replaceStrings [ "." "-" ] [ "00" "00" ] version;
      inherit (stdenv.targetPlatform) system;
    in
      {
        x86_64-linux = fetchurl {
          url = "http://download.roonlabs.com/builds/RoonBridge_linuxx64_${urlVersion}.tar.bz2";
          hash = "sha256-Tx8KmGKh6BNoo2RKJm0HfPHRXiFsz+FtX5gQZ1FCEEg=";
        };
        aarch64-linux = fetchurl {
          url = "http://download.roonlabs.com/builds/RoonBridge_linuxarmv8_${urlVersion}.tar.bz2";
          hash = "sha256-UkdAs+/l9c4j8PNlAZfNNCJogjxZItcDikS+tOjYjA0=";
        };
      }.${system} or (throw "Unsupposed system: ${system}");

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    alsa-lib
    zlib
    stdenv.cc.cc.lib
  ];

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  installPhase =
    let
      fixBin = binPath: ''
        (
          sed -i '/ulimit/d' ${binPath}
          sed -i 's@^SCRIPT=.*@SCRIPT="$(basename "${binPath}")"@' ${binPath}
          wrapProgram ${binPath} \
            --argv0 "$(basename ${binPath})" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ alsa-lib ffmpeg openssl ]}" \
            --prefix PATH : "${lib.makeBinPath [ alsa-utils ffmpeg ]}"
        )
      '';
    in
    ''
      runHook preInstall
      mkdir -p $out
      mv * $out

      rm $out/check.sh
      rm $out/start.sh
      rm $out/VERSION

      ${fixBin "${placeholder "out"}/Bridge/RAATServer"}
      ${fixBin "${placeholder "out"}/Bridge/RoonBridge"}
      ${fixBin "${placeholder "out"}/Bridge/RoonBridgeHelper"}

      mkdir -p $out/bin
      makeWrapper "$out/Bridge/RoonBridge" "$out/bin/RoonBridge" --run "cd $out"

      runHook postInstall
    '';

  meta = with lib; {
    description = "The music player for music lovers";
    changelog = "https://community.roonlabs.com/c/roon/software-release-notes/18";
    homepage = "https://roonlabs.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
