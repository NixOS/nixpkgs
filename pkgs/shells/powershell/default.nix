{ stdenv, autoPatchelfHook, fetchzip, libunwind, libuuid, icu, curl,
  makeWrapper, less, openssl, pam, lttng-ust }:

let platformString = if stdenv.isDarwin then "osx"
                     else if stdenv.isLinux then "linux"
                     else throw "unsupported platform";
    platformSha = if stdenv.isDarwin then "01j92myljgphf68la9q753m5wgfmd0kwlsk441yic7qshcly5xkw"
                     else if stdenv.isLinux then "0al1mrlz3m5ksnq86mqm0axb8bjdxa05j2p5y9bmcykrgkdwi3vk"
                     else throw "unsupported platform";
    platformLdLibraryPath = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH"
                     else if stdenv.isLinux then "LD_LIBRARY_PATH"
                     else throw "unsupported platform";
    libraries = [ libunwind libuuid icu curl openssl lttng-ust ] ++ (if stdenv.isLinux then [ pam ] else []);
in
stdenv.mkDerivation rec {
  name = "powershell-${version}";
  version = "6.0.4";

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
