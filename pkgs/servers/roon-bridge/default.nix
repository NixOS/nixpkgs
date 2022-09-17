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
  version = "1.8-943";

  src =
    let
      urlVersion = builtins.replaceStrings [ "." "-" ] [ "00" "00" ] version;
      inherit (stdenv.targetPlatform) system;
    in
      {
        x86_64-linux = fetchurl {
          url = "http://download.roonlabs.com/builds/RoonBridge_linuxx64_${urlVersion}.tar.bz2";
          hash = "sha256-knmy2zlRh+ehvYKHC7UN60pMCt8bYPuo9kTz2m0pOW0";
        };
        aarch64-linux = fetchurl {
          url = "http://download.roonlabs.com/builds/RoonBridge_linuxarmv8_${urlVersion}.tar.bz2";
          hash = "sha256-urMhtBUjP4HpV9EDZOLLnfnMqhmsWPx0M2+Xdvc8YnU=";
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
      makeWrapper "$out/Bridge/RoonBridge" "$out/bin/RoonBridge" --chdir "$out"

      runHook postInstall
    '';

  meta = with lib; {
    description = "The music player for music lovers";
    changelog = "https://community.roonlabs.com/c/roon/software-release-notes/18";
    homepage = "https://roonlabs.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
