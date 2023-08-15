{ stdenv, lib, fetchurl, gzip, autoPatchelfHook }:
let

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  pname = "codeium";
  version = "1.2.64";
  bin = "$out/bin/codeium_language_server";
  name = "${pname}-${version}.gz";
  srcs = {
    x86_64-linux =  fetchurl {
      inherit name;
      url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_linux_x64.gz";
      hash = "sha256-3dTWFOelojNm8NjjE0PXIiXn/S3rKVXM5llv2nL/2u4=";
    };
    aarch64-linux =  fetchurl {
      inherit name;
      url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_linux_arm.gz";
      hash = "";
    };
    x86_64-darwin =  fetchurl {
      inherit name;
      url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_macos_x64.gz";
      hash = "";
    };
    aarch64-darwin =  fetchurl {
      inherit name;
      url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_macos_arm.gz";
      hash = "";
    };
  };
in stdenv.mkDerivation rec {
  inherit pname version;
  src = srcs.${system} or throwSystem;

  nativeBuildInputs = [ gzip autoPatchelfHook ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    gzip -dc $src > ${bin}
    chmod +x ${bin}
    runHook postInstall
  '';

  meta = rec {
    description = "Codeium language server";
    longDescription = ''
      Codeium proprietary language server, patched for Nix(OS) compatibility.
      bin/language_server_x must be symlinked into the plugin directory, replacing the existing binary.
      For example:
      ```shell
      ln -s "$(which codeium_language_server)" /home/a/.local/share/JetBrains/Rider2023.1/codeium/662505c9b23342478d971f66a530cd102ae35df7/language_server_linux_x64
      ```
    '';
    homepage = "https://codeium.com/";
    downloadPage = homepage;
    changelog = homepage;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ anpin ];
    mainProgram = "codeium";
    platforms = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" "x86_64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
