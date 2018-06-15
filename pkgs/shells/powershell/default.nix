{ stdenv, fetchgit, autoPatchelfHook, fetchzip, libunwind, libuuid, icu, curl,
  makeWrapper, less, openssl, pam, lttng-ust }:

let platformString = if stdenv.isDarwin then "osx"
                     else if stdenv.isLinux then "linux"
                     else throw "unsupported platform";
    platformSha = if stdenv.isDarwin then "1ga4p8xmrxa54v2s6i0q1q7lx2idcmp1jwm0g4jxr54fyn5ay3lf"
                     else if stdenv.isLinux then "000mmv5iblnmwydfdvg5izli3vpb6l14xy4qy3smcikpf0h87fhl"
                     else throw "unsupported platform";
    platformLdLibraryPath = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH"
                     else if stdenv.isLinux then "LD_LIBRARY_PATH"
                     else throw "unsupported platform";
    libraries = [ libunwind libuuid icu curl openssl lttng-ust ] ++ (if stdenv.isLinux then [ pam ] else []);
in
stdenv.mkDerivation rec {
  name = "powershell-${version}";
  version = "6.0.2";

  src = fetchzip {
    url = "https://github.com/PowerShell/PowerShell/releases/download/v${version}/powershell-${version}-${platformString}-x64.tar.gz";
    sha256 = platformSha;
    stripRoot = false;
  };

  buildInputs = [ less ] ++ libraries;
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  # TODO: remove PAGER after upgrading to v6.1.0-preview.1 or later as it has been addressed in
  # https://github.com/PowerShell/PowerShell/pull/6144
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/powershell
    cp -r * $out/share/powershell
    rm $out/share/powershell/DELETE_ME_TO_DISABLE_CONSOLEHOST_TELEMETRY
    makeWrapper $out/share/powershell/pwsh $out/bin/pwsh --prefix ${platformLdLibraryPath} : "${stdenv.lib.makeLibraryPath libraries}" \
                                           --set PAGER ${less}/bin/less --set TERM xterm
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
