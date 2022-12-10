{ stdenv, lib, autoPatchelfHook, fetchzip, libunwind, libuuid, icu, curl
, darwin, makeWrapper, less, openssl_1_1, pam, lttng-ust }:

let archString = if stdenv.isAarch64 then "arm64"
                 else if stdenv.isx86_64 then "x64"
                 else throw "unsupported platform";
    platformString = if stdenv.isDarwin then "osx"
                     else if stdenv.isLinux then "linux"
                     else throw "unsupported platform";
    platformSha = if (stdenv.isDarwin && stdenv.isx86_64) then "sha256-bcLyf/sIaFoS1xS4RLPPC9lVFa94IfQlWeXhyXUTsd0="
                     else if (stdenv.isDarwin && stdenv.isAarch64) then "sha256-2UACjUtyQ611iXmwyiWrGwRVA0FT1cLLMKnY0y4SgoQ="
                     else if (stdenv.isLinux && stdenv.isx86_64) then "sha256-5AZGwxpEqn3X20rCxPcvuqcQib689ui+e0jvri92EdA="
                     else if (stdenv.isLinux && stdenv.isAarch64) then "sha256-90Sz32hm+EcK3nFJOGGCSqIEtW7w48G8mizXvcLb8WU="
                     else throw "unsupported platform";
    platformLdLibraryPath = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH"
                     else if stdenv.isLinux then "LD_LIBRARY_PATH"
                     else throw "unsupported platform";
                     libraries = [ libunwind libuuid icu curl openssl_1_1 ] ++
                       (if stdenv.isLinux then [ pam lttng-ust ] else [ darwin.Libsystem ]);
in
stdenv.mkDerivation rec {
  pname = "powershell";
  version = "7.2.4";

  src = fetchzip {
    url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-${platformString}-${archString}.tar.gz";
    sha256 = platformSha;
    stripRoot = false;
  };

  strictDeps = true;
  buildInputs = [ less ] ++ libraries;
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional stdenv.isLinux autoPatchelfHook;

  installPhase =
  let
    ext = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    pslibs=$out/share/powershell
    mkdir -p $pslibs

    cp -r * $pslibs

    rm -f $pslibs/libcrypto${ext}.1.0.0
    rm -f $pslibs/libssl${ext}.1.0.0

    # At least the 7.1.4-osx package does not have the executable bit set.
    chmod a+x $pslibs/pwsh

    ls $pslibs
  '' + lib.optionalString (!stdenv.isDarwin && !stdenv.isAarch64) ''
    patchelf --replace-needed libcrypto${ext}.1.0.0 libcrypto${ext}.1.1 $pslibs/libmi.so
    patchelf --replace-needed libssl${ext}.1.0.0 libssl${ext}.1.1 $pslibs/libmi.so
  '' + lib.optionalString (!stdenv.isDarwin) ''
    patchelf --replace-needed liblttng-ust${ext}.0 liblttng-ust${ext}.1 $pslibs/libcoreclrtraceptprovider.so
  '' + ''

    mkdir -p $out/bin

    makeWrapper $pslibs/pwsh $out/bin/pwsh \
      --prefix ${platformLdLibraryPath} : "${lib.makeLibraryPath libraries}" \
      --set TERM xterm --set POWERSHELL_TELEMETRY_OPTOUT 1 --set DOTNET_CLI_TELEMETRY_OPTOUT 1
  '';

  dontStrip = true;

  doInstallCheck = true;
  installCheckPhase = ''
    # May need a writable home, seen on Darwin.
    HOME=$TMP $out/bin/pwsh --help > /dev/null
  '';

  meta = with lib; {
    description = "Powerful cross-platform (Windows, Linux, and macOS) shell and scripting language based on .NET";
    homepage = "https://github.com/PowerShell/PowerShell";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with maintainers; [ yrashk srgom p3psi ];
    mainProgram = "pwsh";
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    license = with licenses; [ mit ];
  };

  passthru = {
    shellPath = "/bin/pwsh";
  };

}
