{ stdenv, lib, autoPatchelfHook, fetchzip, libunwind, libuuid, icu, curl
, darwin, makeWrapper, less, openssl_1_1, pam, lttng-ust }:

let platformString = if stdenv.isDarwin then "osx"
                     else if stdenv.isLinux then "linux"
                     else throw "unsupported platform";
    platformSha = if stdenv.isDarwin then "0zv02h3njphrs8kgmicy7w40mmhmigdfl38f2dpwrs6z67f8vrm2"
                     else if stdenv.isLinux then "0dka2q8ijg3ryzwmxapf8aq55d0sgaj6jj0rzj2738in9g4w2hbh"
                     else throw "unsupported platform";
    platformLdLibraryPath = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH"
                     else if stdenv.isLinux then "LD_LIBRARY_PATH"
                     else throw "unsupported platform";
                     libraries = [ libunwind libuuid icu curl openssl_1_1 ] ++
                       (if stdenv.isLinux then [ pam lttng-ust ] else [ darwin.Libsystem ]);
in
stdenv.mkDerivation rec {
  pname = "powershell";
  version = "7.1.0";

  src = fetchzip {
    url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-${platformString}-x64.tar.gz";
    sha256 = platformSha;
    stripRoot = false;
  };

  buildInputs = [ less ] ++ libraries;
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  installPhase =
  let
    ext = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    pslibs=$out/share/powershell
    mkdir -p $pslibs

    cp -r * $pslibs

    rm -f $pslibs/libcrypto${ext}.1.0.0
    rm -f $pslibs/libssl${ext}.1.0.0

    ls $pslibs
  '' + lib.optionalString (!stdenv.isDarwin) ''
    patchelf --replace-needed libcrypto${ext}.1.0.0 libcrypto${ext}.1.1 $pslibs/libmi.so
    patchelf --replace-needed libssl${ext}.1.0.0 libssl${ext}.1.1 $pslibs/libmi.so
  '' + ''

    mkdir -p $out/bin

    makeWrapper $pslibs/pwsh $out/bin/pwsh \
      --prefix ${platformLdLibraryPath} : "${stdenv.lib.makeLibraryPath libraries}" \
      --set TERM xterm --set POWERSHELL_TELEMETRY_OPTOUT 1 --set DOTNET_CLI_TELEMETRY_OPTOUT 1
  '';

  dontStrip = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/pwsh --help > /dev/null
  '';

  meta = with lib; {
    description = "Powerful cross-platform (Windows, Linux, and macOS) shell and scripting language based on .NET";
    homepage = "https://github.com/PowerShell/PowerShell";
    maintainers = with maintainers; [ yrashk srgom ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    license = with licenses; [ mit ];
  };

  passthru = {
    shellPath = "/bin/pwsh";
  };

}
