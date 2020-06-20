{ stdenv, vscode-utils
, fetchurl, unzip
, mono, writeScript, runtimeShell
, jq, clang-tools
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


  openDebugAD7Script = writeScript "OpenDebugAD7" ''
    #!${runtimeShell}
    BIN_DIR="$(cd "$(dirname "$0")" && pwd -P)"
    ${if gdbUseFixed
        then ''
          export PATH=''${PATH}''${PATH:+:}${gdb}/bin
        ''
        else ""}
    ${mono}/bin/mono $BIN_DIR/bin/OpenDebugAD7.exe $*
  '';
in

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "cpptools";
    publisher = "ms-vscode";
    version = "0.27.1";
  };

  vsix = fetchurl {
    url = "https://github.com/microsoft/vscode-cpptools/releases/download/${mktplcRef.version}/cpptools-linux.vsix";
    sha256 = "1if43zis2cy32c6y1zsh0ih0y2kpdag0flkb795b3m5iwm38rjsq";
  };

  unpackPhase = ''
    unzip $src
    cd extension
  '';

  buildInputs = [
    jq
  ];

  postPatch = ''
    mv ./package.json ./package_orig.json

    # 1. Add activation events so that the extension is functional. This listing is empty when unpacking the extension but is filled at runtime.
    # 2. Patch `package.json` so that nix's *gdb* is used as default value for `miDebuggerPath`.
    cat ./package_orig.json | \
      jq --slurpfile actEvts ${./package-activation-events.json} '(.activationEvents) = $actEvts[0]' | \
      jq '(.contributes.debuggers[].configurationAttributes | .attach , .launch | .properties.miDebuggerPath | select(. != null) | select(.default == "/usr/bin/gdb") | .default) = "${gdbDefaultsTo}"' > \
      ./package.json

    # Prevent download/install of extensions
    touch "./install.lock"

    # Mono runtimes from nix package (used by generated `OpenDebugAD7`).
    mv ./debugAdapters/OpenDebugAD7 ./debugAdapters/OpenDebugAD7_orig
    cp -p "${openDebugAD7Script}" "./debugAdapters/OpenDebugAD7"

    # Clang-format from nix package.
    mv  ./LLVM/ ./LLVM_orig
    mkdir "./LLVM/"
    find "${clang-tools}" -mindepth 1 -maxdepth 1 | xargs ln -s -t "./LLVM"

    # Patching  cpptools and cpptools-srv
    elfInterpreter="$(cat $NIX_CC/nix-support/dynamic-linker)"
    patchelf --set-interpreter "$elfInterpreter" ./bin/cpptools
    patchelf --set-interpreter "$elfInterpreter" ./bin/cpptools-srv
    chmod a+x ./bin/cpptools{-srv,}
  '';

    meta = with stdenv.lib; {
      license = licenses.unfree;
      maintainers = [ maintainers.jraygauthier ];
      # A 32 bit linux would also be possible with some effort (specific download of binaries +
      # patching of the elf files with 32 bit interpreter).
      platforms = [ "x86_64-linux" ];
    };
}
