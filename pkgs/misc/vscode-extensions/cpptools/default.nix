{ stdenv, lib, fetchurl, vscode-utils, unzip, dos2unix, mono46, clang-tools, writeScript
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

    src = fetchurl {
      url = https://download.visualstudio.microsoft.com/download/pr/11151953/d3cc8b654bffb8a2f3896d101f3c3155/Bin_Linux.zip;
      sha256 = "12qbxsrdc73cqjb84xdck1xafzhfkcyn6bqbpcy1bxxr3b7hxbii";
    };

    buildInputs = [ unzip ];

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

  cpptoolsJsonFile = fetchurl {
    url = https://download.visualstudio.microsoft.com/download/pr/11070848/7b97d6724d52cae8377c61bb4601c989/cpptools.json;
    sha256 = "124f091aic92rzbg2vg831y22zr5wi056c1kh775djqs3qv31ja6";
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
    version = "0.12.3";
    sha256 = "1dcqy54n1w29xhbvxscd41hdrbdwar6g12zx02f6kh2f1kw34z5z";
  };

  buildInputs = [
    dos2unix
  ];

  prePatch = ''
    dos2unix package.json      
  '';

  patches = [
    ./vscode-cpptools-0-12-3-package-json.patch
  ];

  postPatch = ''
    # Patch `packages.json` so that nix's *gdb* is used as default value for `miDebuggerPath`.
    substituteInPlace "./package.json" \
      --replace "\"default\": \"/usr/bin/gdb\"" "\"default\": \"${gdbDefaultsTo}\""

    # Prevent download/install of extensions
    touch "./install.lock"

    # Move unused files out of the way.
    mv ./debugAdapters/bin/OpenDebugAD7.exe.config ./debugAdapters/bin/OpenDebugAD7.exe.config.unused

    # Bring the `cpptools.json` file at the root of the package, same as the extension would do.
    cp -p "${cpptoolsJsonFile}" "./cpptools.json"

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
