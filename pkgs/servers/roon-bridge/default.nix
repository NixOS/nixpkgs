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
let
  version = "1.8-1125";
  urlVersion = builtins.replaceStrings [ "." "-" ] [ "00" "0" ] version;
  host = stdenv.hostPlatform.system;
  system = if host == "x86_64-linux" then "linuxx64"
           else if host == "aarch64-linux" then "linuxarmv8"
           else throw "Unsupported platform ${host}";
  src = fetchurl {
    url = "https://download.roonlabs.com/updates/stable/RoonBridge_${system}_${urlVersion}.tar.bz2";
    hash = if system == "linuxx64" then "sha256-DbtKPFEz2WIoKTxP+zoehzz+BjfsLZ2ZQk/FMh+zFBM="
           else if system == "linuxarmv8" then "sha256-+przEj96R+f1z4ewETFarF4oY6tT2VW/ukSTgUBLiYk="
           else throw "Unsupported platform ${host}";
  };
in
stdenv.mkDerivation {
  pname = "roon-bridge";
  inherit src version;

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
