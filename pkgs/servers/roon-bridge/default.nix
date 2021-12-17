{ alsa-lib
, alsa-utils
, autoPatchelfHook
, fetchurl
, lib
, makeWrapper
, stdenv
, zlib
}:
let
  inherit (stdenv.targetPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
in
stdenv.mkDerivation rec {
  pname = "roon-bridge";
  version = "1.8-814";

  src =
    let
      urlVersion = builtins.replaceStrings [ "." "-" ] [ "00" "00" ] version;
    in
      {
        x86_64-linux = fetchurl {
          url = "http://download.roonlabs.com/builds/RoonBridge_linuxx64_${urlVersion}.tar.bz2";
          sha256 = "sha256-dersaP/8qkl9k81FrgMieB0P4nKmDwjLW5poqKhEn7A=";
        };
        aarch64-linux = fetchurl {
          url = "http://download.roonlabs.com/builds/RoonBridge_linuxarmv8_${urlVersion}.tar.bz2";
          sha256 = "sha256-zZj7PkLUYYHo3dngqErv1RqynSXi6/D5VPZWfrppX5U=";
        };
      }.${system} or throwSystem;

  buildInputs = [
    alsa-lib
    alsa-utils
    zlib
  ];

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    mv * $out
    runHook postInstall
  '';

  postFixup =
    let
      linkFix = bin: ''
        sed -i '/ulimit/d' ${bin}
        sed -i '/ln -sf/d' ${bin}
        ln -sf $out/RoonMono/bin/mono-sgen $out/RoonMono/bin/${builtins.baseNameOf bin}
      '';
      wrapFix = bin: ''
        wrapProgram ${bin} --prefix PATH : ${lib.makeBinPath [ alsa-utils ]}
      '';
    in
    ''
      ${linkFix "$out/Bridge/RAATServer"}
      ${linkFix "$out/Bridge/RoonBridge"}
      ${linkFix "$out/Bridge/RoonBridgeHelper"}

      ${wrapFix "$out/check.sh"}
      ${wrapFix "$out/start.sh"}
    '';

  meta = with lib; {
    description = "The music player for music lovers";
    homepage = "https://roonlabs.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
