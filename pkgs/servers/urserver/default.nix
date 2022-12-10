{ lib, stdenv
, fetchurl
, autoPatchelfHook
, bluez
, libX11
, libXtst
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "urserver";
  version = "3.10.0.2467";

  src = fetchurl {
    url = "https://www.unifiedremote.com/static/builds/server/linux-x64/${builtins.elemAt (builtins.splitVersion version) 3}/urserver-${version}.tar.gz";
    sha256 = "sha256-IaLRhia6mb4h7x5MbBRtPJxJ3uTlkfOzmoTwYzwfbWA=";
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
    wrapProgram $out/bin/urserver --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
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
}
