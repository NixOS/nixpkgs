{ lib
, stdenv
, fetchurl
, less
, makeWrapper
, autoPatchelfHook
, curl
, icu
, libuuid
, libunwind
, openssl
, darwin
, lttng-ust
, pam
, testers
, powershell
, writeShellScript
, common-updater-scripts
, gnused
, jq
}:

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
  platformLdLibraryPath = {
    darwin = "DYLD_FALLBACK_LIBRARY_PATH";
    linux = "LD_LIBRARY_PATH";
  }.${stdenv.hostPlatform.parsed.kernel.name} or (throw "unsupported platform");
in
stdenv.mkDerivation rec {
  pname = "powershell";
  version = "7.4.2";

  src = passthru.sources.${stdenv.hostPlatform.system}
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = ".";

  strictDeps = true;

  nativeBuildInputs = [
    less
    makeWrapper
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    curl
    icu
    libuuid
    libunwind
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.Libsystem
  ] ++ lib.optionals stdenv.isLinux [
    lttng-ust
    pam
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/powershell}
    cp -R * $out/share/powershell
    chmod +x $out/share/powershell/pwsh
    makeWrapper $out/share/powershell/pwsh $out/bin/pwsh \
      --prefix ${platformLdLibraryPath} : "${lib.makeLibraryPath buildInputs}" \
      --set TERM xterm \
      --set POWERSHELL_TELEMETRY_OPTOUT 1 \
      --set DOTNET_CLI_TELEMETRY_OPTOUT 1

  '' + lib.optionalString stdenv.isLinux ''
    patchelf --replace-needed liblttng-ust${ext}.0 liblttng-ust${ext}.1 $out/share/powershell/libcoreclrtraceptprovider.so

  '' + ''
    runHook postInstall
  '';

  dontStrip = true;

  passthru = {
    shellPath = "/bin/pwsh";
    sources = {
      aarch64-darwin = fetchurl {
        url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-osx-arm64.tar.gz";
        hash = "sha256-Gg1wXIw/x/s0dgCkycZ4fC4eK+zIoduHr8nHvBOPFm4=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-linux-arm64.tar.gz";
        hash = "sha256-AGAhaUqeDOliRX0jGJ48uIrgMIY7IhkH+PuJHflJeus=";
      };
      x86_64-darwin = fetchurl {
        url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-osx-x64.tar.gz";
        hash = "sha256-jH4XY/XjYljkVV4DlOq+f8lwWDcFGA7yaVFKgGUVz+I=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-linux-x64.tar.gz";
        hash = "sha256-NmBdw3l53lry4QeDv3DArYFQUh6B5tfJMiA267iX5/4=";
      };
    };
    tests.version = testers.testVersion {
      package = powershell;
      command = "HOME=$(mktemp -d) pwsh --version";
    };
    updateScript = writeShellScript "update-powershell" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ common-updater-scripts curl gnused jq ]}"
      NEW_VERSION=$(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest | jq .tag_name --raw-output | sed -e 's/v//')

      if [[ "${version}" = "$NEW_VERSION" ]]; then
        echo "The new version same as the old version."
        exit 0
      fi

      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "powershell" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = with lib; {
    description = "Powerful cross-platform (Windows, Linux, and macOS) shell and scripting language based on .NET";
    homepage = "https://microsoft.com/PowerShell";
    license = licenses.mit;
    mainProgram = "pwsh";
    maintainers = with maintainers; [ wegank ];
    platforms = builtins.attrNames passthru.sources;
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
  };
}
