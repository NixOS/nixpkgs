<<<<<<< HEAD
{ stdenv, lib, autoPatchelfHook, fetchurl, libunwind, libuuid, icu, curl
, darwin, makeWrapper, less, openssl, pam, lttng-ust }:
=======
{ stdenv, lib, autoPatchelfHook, fetchzip, libunwind, libuuid, icu, curl
, darwin, makeWrapper, less, openssl_1_1, pam, lttng-ust }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let archString = if stdenv.isAarch64 then "arm64"
                 else if stdenv.isx86_64 then "x64"
                 else throw "unsupported platform";
    platformString = if stdenv.isDarwin then "osx"
                     else if stdenv.isLinux then "linux"
                     else throw "unsupported platform";
<<<<<<< HEAD
    platformHash = {
      x86_64-darwin = "sha256-FX3OyVzwU+Ms2tgjpZ4dPdjeJx2H5541dQZAjhI3n1U=";
      aarch64-darwin = "sha256-Dg7FRF5inRnzP6tjDhIgHTJ1J2EQXnegqimZPK574WQ=";
      x86_64-linux = "sha256-6F1VROE6kk+LLEpdwtQ6vkbkZjP4no0TjTnAqurLmXY=";
      aarch64-linux = "sha256-NO4E2TOUIYyUFJmi3zKJzOyP0/rTPTZgJZcebVNkSfk=";
    }.${stdenv.hostPlatform.system} or (throw "unsupported platform");
    platformLdLibraryPath = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH"
                     else if stdenv.isLinux then "LD_LIBRARY_PATH"
                     else throw "unsupported platform";
                     libraries = [ libunwind libuuid icu curl openssl ] ++
=======
    platformSha = if (stdenv.isDarwin && stdenv.isx86_64) then "sha256-JKB7Oy+3KWtVo1Aqmc7vZiO88FrF9+8N/tdGlvIQolM="
                     else if (stdenv.isDarwin && stdenv.isAarch64) then "sha256-9UwB1tT2VaW+favw/KWPziFMSRWcw7AqeeZvbaGOBqc="
                     else if (stdenv.isLinux && stdenv.isx86_64) then "sha256-kAcT9av4PFZfYqpS0XwKC0IiquUcVtN30Mq649PUnSM="
                     else if (stdenv.isLinux && stdenv.isAarch64) then "sha256-3Lm9WYVcfkEVfji/h52VqFy1Jo1AiSQ22JhEGiCPzzM="
                     else throw "unsupported platform";
    platformLdLibraryPath = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH"
                     else if stdenv.isLinux then "LD_LIBRARY_PATH"
                     else throw "unsupported platform";
                     libraries = [ libunwind libuuid icu curl openssl_1_1 ] ++
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
                       (if stdenv.isLinux then [ pam lttng-ust ] else [ darwin.Libsystem ]);
in
stdenv.mkDerivation rec {
  pname = "powershell";
<<<<<<< HEAD
  version = "7.3.4";

  src = fetchurl {
    url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-${platformString}-${archString}.tar.gz";
    hash = platformHash;
  };

  sourceRoot = ".";

=======
  version = "7.3.2";

  src = fetchzip {
    url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-${platformString}-${archString}.tar.gz";
    sha256 = platformSha;
    stripRoot = false;
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
    # At least the 7.1.4-osx package does not have the executable bit set.
    chmod a+x $pslibs/pwsh

  '' + lib.optionalString (stdenv.isLinux && stdenv.isx86_64) ''
    patchelf --replace-needed libcrypto${ext}.1.0.0 libcrypto${ext} $pslibs/libmi.so
    patchelf --replace-needed libssl${ext}.1.0.0 libssl${ext} $pslibs/libmi.so
  '' + lib.optionalString stdenv.isLinux ''
=======
    rm -f $pslibs/libcrypto${ext}.1.0.0
    rm -f $pslibs/libssl${ext}.1.0.0

    # At least the 7.1.4-osx package does not have the executable bit set.
    chmod a+x $pslibs/pwsh

    ls $pslibs
  '' + lib.optionalString (!stdenv.isDarwin && !stdenv.isAarch64) ''
    patchelf --replace-needed libcrypto${ext}.1.0.0 libcrypto${ext}.1.1 $pslibs/libmi.so
    patchelf --replace-needed libssl${ext}.1.0.0 libssl${ext}.1.1 $pslibs/libmi.so
  '' + lib.optionalString (!stdenv.isDarwin) ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
