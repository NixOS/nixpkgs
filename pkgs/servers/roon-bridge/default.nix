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

  # N.B. The URL is unstable. I've asked for them to provide a stable URL but
  # they have ignored me. If this package fails to build for you, you may need
  # to update the version and sha256.
  # c.f. https://community.roonlabs.com/t/latest-roon-server-is-not-available-for-download-on-nixos/118129
  src = {
    x86_64-linux = fetchurl {
      url = "https://web.archive.org/web/20210729154257/http://download.roonlabs.com/builds/RoonBridge_linuxx64.tar.bz2";
      sha256 = "sha256-dersaP/8qkl9k81FrgMieB0P4nKmDwjLW5poqKhEn7A=";
    };
    aarch64-linux = fetchurl {
      url = "https://web.archive.org/web/20210803071334/http://download.roonlabs.com/builds/RoonBridge_linuxarmv8.tar.bz2";
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
    platforms = platforms.linux;
  };
}
