{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  bluez,
  libX11,
  libXtst,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "urserver";
  version = "3.13.0.2505";

  src = fetchurl {
    url = "https://www.unifiedremote.com/static/builds/server/linux-x64/${builtins.elemAt (builtins.splitVersion finalAttrs.version) 3}/urserver-${finalAttrs.version}.tar.gz";
    hash = "sha256-rklv6Ppha1HhEPunbL8ELYdQ9Z1FN4FrVsNwny3/gA4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    bluez
    libX11
    libXtst
  ];

  installPhase = ''
    install -m755 -D urserver $out/bin/urserver
    wrapProgram $out/bin/urserver --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    cp -r remotes $out/bin/remotes
    cp -r manager $out/bin/manager
  '';

  meta = with lib; {
    homepage = "https://www.unifiedremote.com/";
    description = "The one-and-only remote for your computer";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ sfrijters ];
    platforms = [ "x86_64-linux" ];
  };
})
