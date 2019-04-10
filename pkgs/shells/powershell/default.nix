{ stdenv, autoPatchelfHook, fetchzip, libunwind, libuuid, icu, curl
, darwin, makeWrapper, less, openssl, pam, lttng-ust }:

let platformString = if stdenv.isDarwin then "osx"
                     else if stdenv.isLinux then "linux"
                     else throw "unsupported platform";
    platformSha = if stdenv.isDarwin then "1jcrrgybcyq9kwyqxshsfm5fy3sa77h3795xx3rvrs8k434nl1yb"
                     else if stdenv.isLinux then "1hlis827wmnjcy4h8va50093pmnqdhkbnbimmkymzmcvmkbmi9nx"
                     else throw "unsupported platform";
    platformLdLibraryPath = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH"
                     else if stdenv.isLinux then "LD_LIBRARY_PATH"
                     else throw "unsupported platform";
                     libraries = [ libunwind libuuid icu curl openssl ] ++
                       (if stdenv.isLinux then [ pam lttng-ust ] else [ darwin.Libsystem ]);
in
stdenv.mkDerivation rec {
  name = "powershell-${version}";
  version = "6.2.0";

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
                                           --set TERM xterm --set POWERSHELL_TELEMETRY_OPTOUT 1
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Cross-platform (Windows, Linux, and macOS) automation and configuration tool/framework";
    homepage = https://github.com/PowerShell/PowerShell;
    maintainers = [ maintainers.yrashk ];
    platforms = platforms.unix;
    license = with licenses; [ mit ];
  };

}
