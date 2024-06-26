{
  stdenv,
  lib,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "github-copilot-intellij-agent";
  version = "1.4.5.4049";

  src = fetchurl {
    name = "${pname}-${version}-plugin.zip";
    url = "https://plugins.jetbrains.com/plugin/download?updateId=454005";
    hash = "sha256-ibu3OcmtyLHuumhJQ6QipsNEIdEhvLUS7sb3xmnaR0U=";
  };

  nativeBuildInputs = [ unzip ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    unzip -p $src github-copilot-intellij/copilot-agent/bin/copilot-agent-${
      if stdenv.isDarwin then (if stdenv.isAarch64 then "macos-arm64" else "macos") else "linux"
    } | install -m755 /dev/stdin $out/bin/copilot-agent

    runHook postInstall
  '';

  # https://discourse.nixos.org/t/unrelatable-error-when-working-with-patchelf/12043
  # https://github.com/NixOS/nixpkgs/blob/db0d8e10fc1dec84f1ccb111851a82645aa6a7d3/pkgs/development/web/now-cli/default.nix
  preFixup =
    let
      binaryLocation = "$out/bin/copilot-agent";
      libPath = lib.makeLibraryPath [ stdenv.cc.cc ];
    in
    ''
      orig_size=$(stat --printf=%s ${binaryLocation})

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ${binaryLocation}
      patchelf --set-rpath ${libPath} ${binaryLocation}
      chmod +x ${binaryLocation}

      new_size=$(stat --printf=%s ${binaryLocation})

      var_skip=20
      var_select=22
      shift_by=$(expr $new_size - $orig_size)

      function fix_offset {
        location=$(grep -obUam1 "$1" ${binaryLocation} | cut -d: -f1)
        location=$(expr $location + $var_skip)
        value=$(dd if=${binaryLocation} iflag=count_bytes,skip_bytes skip=$location \
                   bs=1 count=$var_select status=none)
        value=$(expr $shift_by + $value)
        echo -n $value | dd of=${binaryLocation} bs=1 seek=$location conv=notrunc
      }

      fix_offset PAYLOAD_POSITION
      fix_offset PRELUDE_POSITION
    '';

  dontStrip = true;

  meta = rec {
    description = "GitHub copilot IntelliJ plugin's native component";
    longDescription = ''
      The GitHub copilot IntelliJ plugin's native component.
      bin/copilot-agent must be symlinked into the plugin directory, replacing the existing binary.

      For example:

      ```shell
      ln -fs /run/current-system/sw/bin/copilot-agent ~/.local/share/JetBrains/IntelliJIdea2022.2/github-copilot-intellij/copilot-agent/bin/copilot-agent-linux
      ```
    '';
    homepage = "https://plugins.jetbrains.com/plugin/17718-github-copilot";
    downloadPage = homepage;
    changelog = homepage;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ hacker1024 ];
    mainProgram = "copilot-agent";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
