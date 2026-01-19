{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapQtAppsHook,
  gnustep-libobjc,
  libbsd,
  libffi_3_3,
  libxml2,
  ncurses6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hopper";
  version = "5.19.4";
  rev = "v4";

  src = fetchurl {
    url = "https://www.hopperapp.com/downloader/public/Hopper-${finalAttrs.rev}-${finalAttrs.version}-Linux-demo.pkg.tar.xz";
    curlOptsList = [
      "--user-agent"
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
      "--referer"
      "https://www.hopperapp.com"
    ];
    hash = "sha256-NYnMJK9F3YxspjriyiLM+vV1HpEunGvznOesQ/FpTl4=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    wrapQtAppsHook
  ];

  buildInputs = [
    gnustep-libobjc
    libbsd
    libffi_3_3
    ncurses6
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib
    install -Dm755 opt/hopper-${finalAttrs.rev}/bin/Hopper $out/bin/hopper
    cp --archive \
      opt/hopper-${finalAttrs.rev}/lib/libBlocksRuntime.so* \
      opt/hopper-${finalAttrs.rev}/lib/libdispatch.so* \
      opt/hopper-${finalAttrs.rev}/lib/libgnustep-base.so* \
      opt/hopper-${finalAttrs.rev}/lib/libHopperCore.so* \
      opt/hopper-${finalAttrs.rev}/lib/libkqueue.so* \
      opt/hopper-${finalAttrs.rev}/lib/libobjcxx.so* \
      opt/hopper-${finalAttrs.rev}/lib/libpthread_workqueue.so* \
      $out/lib
    cp -r usr/share $out/share
    substituteInPlace $out/share/applications/hopper-${finalAttrs.rev}.desktop \
      --replace-fail "Exec=/opt/hopper-${finalAttrs.rev}/bin/Hopper" "Exec=hopper"

    runHook postInstall
  '';

  preFixup = ''
    # Fix libxml2 breakage. See https://github.com/NixOS/nixpkgs/pull/396195#issuecomment-2881757108
    mkdir -p "$out/lib"
    ln -s "${lib.getLib libxml2}/lib/libxml2.so" "$out/lib/libxml2.so.2"
  '';

  meta = {
    homepage = "https://www.hopperapp.com/index.html";
    description = "MacOS and Linux Disassembler";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ Enteee ];
    platforms = lib.platforms.linux;
  };
})
