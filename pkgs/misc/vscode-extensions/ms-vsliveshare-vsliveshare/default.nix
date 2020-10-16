# Baseed on previous attempts:
#  -  <https://github.com/msteen/nixos-vsliveshare/blob/master/pkgs/vsliveshare/default.nix>
#  -  <https://github.com/NixOS/nixpkgs/issues/41189>
{ lib, gccStdenv, vscode-utils, autoPatchelfHook, bash, file, makeWrapper, dotnet-sdk_3
, curl, gcc, icu, libkrb5, libsecret, libunwind, libX11, lttng-ust, openssl, utillinux, zlib
, desktop-file-utils, xprop
}:

with lib;

let
  # https://docs.microsoft.com/en-us/visualstudio/liveshare/reference/linux#install-prerequisites-manually
  libs = [
    # .NET Core
    openssl
    libkrb5
    zlib
    icu

    # Credential Storage
    libsecret

    # NodeJS
    libX11

    # https://github.com/flathub/com.visualstudio.code.oss/issues/11#issuecomment-392709170
    libunwind
    lttng-ust
    curl

    # General
    gcc.cc.lib
    utillinux # libuuid
  ];

in ((vscode-utils.override { stdenv = gccStdenv; }).buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vsliveshare";
    publisher = "ms-vsliveshare";
    version = "1.0.2902";
    sha256 = "0fx2vi0wxamcwqcgcx7wpg8hi7f1c2pibrmd2qy2whilpsv3gzmb";
  };
}).overrideAttrs(attrs: {
  buildInputs = attrs.buildInputs ++ libs ++ [ autoPatchelfHook bash file makeWrapper ];

  # Using a patch file won't work, because the file changes too often, causing the patch to fail on most updates.
  # Rather than patching the calls to functions, we modify the functions to return what we want,
  # which is less likely to break in the future.
  postPatch = ''
    sed -i \
      -e 's/updateExecutablePermissionsAsync() {/& return;/' \
      -e 's/isInstallCorrupt(traceSource, manifest) {/& return false;/' \
      out/prod/extension-prod.js

    declare ext_unique_id
    ext_unique_id="$(basename "$out")"

    # Fix extension attempting to write to 'modifiedInternalSettings.json'.
    # Move this write to the tmp directory indexed by the nix store basename.
    sed -i \
      -E -e $'s/path\.resolve\(constants_1\.EXTENSION_ROOT_PATH, \'\.\/modifiedInternalSettings\.json\'\)/path.join\(os.tmpdir(), "'$ext_unique_id'" + "-modifiedInternalSettings.json"\)/g' \
      out/prod/extension-prod.js

    # Fix extension attempting to write to 'vsls-agent.lock'.
    # Move this write to the tmp directory indexed by the nix store basename.
    sed -i \
      -E -e $'s/(Agent_1.getAgentPath\(\) \+ \'.lock\')/path.join\(os.tmpdir(), "'$ext_unique_id'" + "-vsls-agent.lock"\)/g' \
      out/prod/extension-prod.js

    # TODO: Under 'node_modules/@vsliveshare/vscode-launcher-linux' need to hardcode path to 'desktop-file-install'
    # 'update-desktop-database' and 'xprop'. Might want to wrap the script instead.
  '';

  # Support for the `postInstall` hook was added only in nixos-20.03,
  # so for backwards compatibility reasons lets not use it yet.
  installPhase = attrs.installPhase + ''
    # Support both the new and old directory structure of vscode extensions.
    if [[ -d $out/ms-vsliveshare.vsliveshare ]]; then
      cd $out/ms-vsliveshare.vsliveshare
    elif [[ -d $out/share/vscode/extensions/ms-vsliveshare.vsliveshare ]]; then
      cd $out/share/vscode/extensions/ms-vsliveshare.vsliveshare
    else
      echo "Could not find extension directory 'ms-vsliveshare.vsliveshare'." >&2
      exit 1
    fi

    bash -s <<ENDSUBSHELL
    shopt -s extglob

    # A workaround to prevent the journal filling up due to diagnostic logging.
    # See: https://github.com/MicrosoftDocs/live-share/issues/1272
    # See: https://unix.stackexchange.com/questions/481799/how-to-prevent-a-process-from-writing-to-the-systemd-journal
    gcc -fPIC -shared -ldl -o dotnet_modules/noop-syslog.so ${./noop-syslog.c}

    # Normally the copying of the right executables is done externally at a later time,
    # but we want it done at installation time.
    cp dotnet_modules/exes/linux-x64/* dotnet_modules

    # The required executables are already copied over,
    # and the other runtimes won't be used and thus are just a waste of space.
    rm -r dotnet_modules/exes dotnet_modules/runtimes/!(linux-x64)

    # Not all executables and libraries are executable, so make sure that they are.
    find . -type f ! -executable -exec file {} + | grep -w ELF | cut -d ':' -f1 | xargs -rd'\n' chmod +x

    # Not all scripts are executed by passing them to a shell, so they need to be executable as well.
    find . -type f -name '*.sh' ! -executable -exec chmod +x {} +

    # Lock the extension downloader.
    touch install-linux.Lock externalDeps-linux.Lock
    ENDSUBSHELL
  '';

  rpath = makeLibraryPath libs;

  postFixup = ''
    # We cannot use `wrapProgram`, because it will generate a relative path,
    # which will break when copying over the files.
    mv dotnet_modules/vsls-agent{,-wrapped}
    makeWrapper $PWD/dotnet_modules/vsls-agent{-wrapped,} \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --set LD_PRELOAD $PWD/dotnet_modules/noop-syslog.so \
      --set DOTNET_ROOT ${dotnet-sdk_3}

    for bn in check-reqs.sh install.sh uninstall.sh; do
      wrapProgram "$PWD/node_modules/@vsliveshare/vscode-launcher-linux/$bn" \
        --prefix PATH : "${makeBinPath [desktop-file-utils xprop]}"
    done
  '';

  meta = {
    description = "Live Share lets you achieve greater confidence at speed by streamlining collaborative editing, debugging, and more in real-time during development";
    homepage = "https://aka.ms/vsls-docs";
    license = licenses.unfree;
    maintainers = with maintainers; [ jraygauthier ];
    platforms = [ "x86_64-linux" ];
  };
})
