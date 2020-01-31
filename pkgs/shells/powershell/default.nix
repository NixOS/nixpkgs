{ stdenv, autoPatchelfHook, fetchzip, libunwind, libuuid, icu, curl
, darwin, makeWrapper, less, openssl_1_0_2, pam, lttng-ust }:

let platformString = if stdenv.isDarwin then "osx"
                     else if stdenv.isLinux then "linux"
                     else throw "unsupported platform";
    platformSha = if stdenv.isDarwin then "0jb2xm79m3m14zk7v730ai1zvxcb5a13jbkkya0qy7332k6gn6bl"
                     else if stdenv.isLinux then "1yqgb2h69yi23iw3xsv574zdycacsg70pdwkpvqbbw4xig5p3p9m"
                     else throw "unsupported platform";
    platformLdLibraryPath = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH"
                     else if stdenv.isLinux then "LD_LIBRARY_PATH"
                     else throw "unsupported platform";
                     libraries = [ libunwind libuuid icu curl openssl_1_0_2 ] ++
                       (if stdenv.isLinux then [ pam lttng-ust ] else [ darwin.Libsystem ]);
in
stdenv.mkDerivation rec {
  pname = "powershell";
  version = "6.2.4";

  src = fetchzip {
    url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-${platformString}-x64.tar.gz";
    sha256 = platformSha;
    stripRoot = false;
  };

  buildInputs = [ less ] ++ libraries;
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/powershell
    cp -r * $out/share/powershell
    makeWrapper $out/share/powershell/pwsh $out/bin/pwsh --prefix ${platformLdLibraryPath} : "${stdenv.lib.makeLibraryPath libraries}" \
                                           --set TERM xterm --set POWERSHELL_TELEMETRY_OPTOUT 1 --set DOTNET_CLI_TELEMETRY_OPTOUT 1
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Cross-platform (Windows, Linux, and macOS) automation and configuration tool/framework";
    homepage = https://github.com/PowerShell/PowerShell;
    maintainers = [ maintainers.yrashk ];
    platforms = platforms.unix;
    license = with licenses; [ mit ];
  };

  passthru = { 
    shellPath = "/bin/pwsh"; 
  };

}
