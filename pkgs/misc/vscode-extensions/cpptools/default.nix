{ stdenv, lib, fetchurl, fetchzip, vscode-utils, jq, mono46, clang-tools, writeScript
, gdbUseFixed ? true, gdb # The gdb default setting will be fixed to specified. Use version from `PATH` otherwise.
}:

assert gdbUseFixed -> null != gdb;

/*
  Note that this version of the extension still has some nix specific issues
  which could not be fixed merely by patching (inside a C# dll).

  In particular, the debugger requires either gnome-terminal or xterm. However
  instead of looking for the terminal executable in `PATH`, for any linux platform
  the dll uses an hardcoded path to one of these.

  So, in order for debugging to work properly, you merely need to create symlinks
  to one of these terminals at the appropriate location.

  The good news is the the utility library is open source and with some effort
  we could build a patched version ourselves. See:

  <https://github.com/Microsoft/MIEngine/blob/2885386dc7f35e0f1e44827269341e786361f28e/src/MICore/TerminalLauncher.cs#L156>

  Also, the extension should eventually no longer require an external terminal. See:

  <https://github.com/Microsoft/vscode-cpptools/issues/35>

  Once the symbolic link temporary solution taken, everything shoud run smootly.
*/

let
  gdbDefaultsTo = if gdbUseFixed then "${gdb}/bin/gdb" else "gdb";

  langComponentBinaries = stdenv.mkDerivation {
    name = "cpptools-language-component-binaries";

    src = fetchzip {
      url = https://download.visualstudio.microsoft.com/download/pr/11991016/8a81aa8f89aac452956b0e4c68e6620b/Bin_Linux.zip;
      sha256 = "0ma59fxfldbgh6ijlvfbs3hnl4g0cnw5gs6286zdrp065n763sv4";
    };

    patchPhase = ''
      elfInterpreter="${stdenv.glibc.out}/lib/ld-linux-x86-64.so.2"
      patchelf --set-interpreter "$elfInterpreter" ./Microsoft.VSCode.CPP.Extension.linux
      patchelf --set-interpreter "$elfInterpreter" ./Microsoft.VSCode.CPP.IntelliSense.Msvc.linux
      chmod a+x ./Microsoft.VSCode.CPP.Extension.linux ./Microsoft.VSCode.CPP.IntelliSense.Msvc.linux
    '';

    installPhase = ''
      mkdir -p "$out/bin"
      find . -mindepth 1 -maxdepth 1 | xargs cp -a -t "$out/bin"
    '';
  };

  openDebugAD7Script = writeScript "OpenDebugAD7" ''
    #!${stdenv.shell}
    BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"
    ${if gdbUseFixed
        then ''
          export PATH=''${PATH}''${PATH:+:}${gdb}/bin
        ''
        else ""}
    ${mono46}/bin/mono $BIN_DIR/bin/OpenDebugAD7.exe $*
  '';
in

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "cpptools";
    publisher = "ms-vscode";
    version = "0.17.6";
    sha256 = "2625be8b922ffc199e1c776f784d39b6e004523212f7956c93ae40f9040ce6d5";
  };

  buildInputs = [
    jq
  ];

  postPatch = ''
    mv ./package.json ./package_ori.json

    # 1. Add activation events so that the extension is functional. This listing is empty when unpacking the extension but is filled at runtime.
    # 2. Patch `packages.json` so that nix's *gdb* is used as default value for `miDebuggerPath`.
    cat ./package_ori.json | \
      jq --slurpfile actEvts ${./package-activation-events-0-16-1.json} '(.activationEvents) = $actEvts[0]' | \
      jq '(.contributes.debuggers[].configurationAttributes | .attach , .launch | .properties.miDebuggerPath | select(. != null) | select(.default == "/usr/bin/gdb") | .default) = "${gdbDefaultsTo}"' > \
      ./package.json

    # Patch `packages.json` so that nix's *gdb* is used as default value for `miDebuggerPath`.
    substituteInPlace "./package.json" \
      --replace "\"default\": \"/usr/bin/gdb\"" "\"default\": \"${gdbDefaultsTo}\""

    # Prevent download/install of extensions
    touch "./install.lock"

    # Move unused files out of the way.
    mv ./debugAdapters/bin/OpenDebugAD7.exe.config ./debugAdapters/bin/OpenDebugAD7.exe.config.unused

    # Combining the language component binaries as part of our package.
    find "${langComponentBinaries}/bin" -mindepth 1 -maxdepth 1 | xargs cp -p -t "./bin"

    # Mono runtimes from nix package (used by generated `OpenDebugAD7`).
    rm "./debugAdapters/OpenDebugAD7"
    cp -p "${openDebugAD7Script}" "./debugAdapters/OpenDebugAD7"

    # Clang-format from nix package.
    mkdir -p "./LLVM"
    find "${clang-tools}" -mindepth 1 -maxdepth 1 | xargs ln -s -t "./LLVM"
  '';

    meta = with stdenv.lib; {
      license = licenses.unfree;
      maintainers = [ maintainers.jraygauthier ];
      # A 32 bit linux would also be possible with some effort (specific download of binaries +
      # patching of the elf files with 32 bit interpreter).
      platforms = [ "x86_64-linux" ];
    };
}
